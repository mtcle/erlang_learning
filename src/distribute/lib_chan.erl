%%%-------------------------------------------------------------------
%%% @author Lenovo
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. 9月 2020 15:19
%%%-------------------------------------------------------------------
-module(lib_chan).
-author("Lenovo").

%% API
-export([cast/2,start_server/0,start_server/1,connect/5,disconnect/1,rpc/2]).
-import(lists,[map/2,member/2,foreach/2]).
-import(lib_chan_mm,[send/2,close/1]).


start_server() ->
  case os:getenv("HOME") of
    false ->
      exit({ebadEnv, "HOME"});
    Home ->
      start_server(Home ++ "/.erlang_config/lib_chan.conf")
  end.
start_server(Conf) ->
  io:format("lib_chan starting:~p~n", [Conf]),
  case file:consult(Conf) of
    {ok, ConfData} ->
      io:format("Conf~p~n ", [ConfData]),
      case check_terms(ConfData) of
        [] ->
          start_server1(ConfData);
        Errors ->
          exit({eDaemonConfig, Errors})
      end;
    {error, Why} ->
      exit(eDaemonConfig, Why)
  end.

%% 检查配置的端口等信息是否合规
check_terms(ConfData) ->
  L = map(fun check_term/1, ConfData),
  [X || {error, X} <- L].
check_term({port, P}) when is_integer(P) -> ok;
check_term({service, _, password, _,mfa, _, _,_}) -> ok;
check_term(X) -> {error, {badTerm, X}}.

start_server1(ConfigData) ->
  register(lib_chan, spawn(fun() -> start_server2(ConfigData) end)).

start_server2(ConfigData) ->
  [Port] = [P || {port, P} <- ConfigData],
  start_port_server(Port, ConfigData).

start_port_server(Port, ConfigData) ->
  lib_chan_cs:start_raw_server(Port, fun(Socket) -> start_port_instance(Socket, ConfigData) end, 100, 4).

start_port_instance(Socket, ConfigData) ->
  S = self(),
  Controller = spawn_link(fun() -> start_erl_port_server(S, ConfigData) end),
  lib_chan_mm:loop(Socket, Controller).

start_erl_port_server(MM, ConfigData) ->
  receive
    {chan, MM, {startService, Mod, ArgC}} ->
      case get_service_definition(Mod, ConfigData) of
        {yes, Pwd, MFA} ->
          case Pwd of
            none ->
              send(MM, ack),
              really_start(MM, ArgC, MFA);
            _ ->
              do_authentication(Pwd, MM, ArgC, MFA)
          end;
        no ->
          io:format("sending bad service~n"),
          send(MM, badService),
          close(MM)
      end;
    Any ->
      io:format("erl port server got:~p~p~n", [MM, Any]),
      exit({protocolViolation, Any})
  end.


really_start(MM, ArgC, {Mod, Func, ArgS}) ->
  case (catch apply(Mod, Func, [MM, ArgC, ArgS])) of
    {"EXIT", normal} ->
      true;
    {"EXIT", Why} ->
      io:format("server error:~p~n", [Why]);
    Why ->
      io:format("Server error should die whit exit(normal) was:~p~n", [Why])
  end.


get_service_definition(Mod, [{service, Mod, password, Pwd, mfa, M, F, A} | _]) ->
  {yes, Pwd, {M, F, A}};
get_service_definition(Name, [_ | T])->
  get_service_definition(Name,T);
get_service_definition(_, []) ->
  no.

%%客户端连接
connect(Host, Port, Service, Secret, ArgC) ->
  S = self(),
  MM = spawn(fun() -> connect(S, Host, Port) end),
  receive
    {MM, ok} ->
      case authenticate(MM, Service, Secret, ArgC) of
        ok -> {ok, MM};
        Error -> Error
      end;
    {MM, Error} ->
      Error
  end.



connect(Parent, Host, Port) ->
  case lib_chan_cs:start_raw_client(Host, Port, 4) of
    {ok, Socket} ->
      Parent ! {self(), ok},
      lib_chan_mm:loop(Socket, Parent);
    Error ->
      Parent ! {self(), Error}
  end.

%% 做密码认证，调用认证模块的校验功能
do_authentication(Pwd,MM,ArgC,MFA)->
  C=lib_chan_auth:make_challenge(),
  send(MM,{challenge,C}),
  receive
    {chan,MM,{response,R}}->
      case lib_chan_auth:is_response_correct(C,R,Pwd)of
        true->
          send(MM,ack),
          io:format("auth success!~n"),
          really_start(MM,ArgC,MFA);
        false->
          io:format("auth failed!~n"),
          send(MM,authFail),
          close(MM)
      end
  end
.

authenticate(MM, Service, Secret, ArgC) ->
  send(MM, {startService, Service, ArgC}),
  receive
    {chan, MM, ack} ->
      ok;
    {chan, MM, {challenge, C}} ->
      R = lib_chan_auth:make_response(C, Secret),
      send(MM, {response, R}),
      receive
        {chan, MM, ack} ->
          ok;
        {chan, MM, authFail} ->
          wait_close(MM),
          {error, authFail};
        Other ->
          {error, Other}
      end;
    {chan, MM, badService} ->
      wait_close(MM),
      {error, badService};
    Other ->
      {error, Other}
  end.

wait_close(MM) ->
  receive
    {chan_closed, MM} ->
      true
  after 3000 ->
    io:format("-------server error-----"),
    true

  end.

disconnect(MM) -> close(MM).

rpc(MM, Q) ->
  send(MM, Q),
  receive
    {chan, MM, Reply} ->
      Reply
  end.

cast(MM, Q) ->
  send(MM, Q).