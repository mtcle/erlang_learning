%%%-------------------------------------------------------------------
%%% @author Lenovo
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%% 负责建立客户端和服务端的通信，
%%% @end
%%% Created : 14. 9月 2020 16:37
%%%-------------------------------------------------------------------
-module(lib_chan_cs).
-author("Lenovo").

%% API
-export([start_raw_server/4,start_raw_client/3]).
-export([stop/1]).
-export([children/1]).
start_raw_client(Host,Port,PacketLength)->
  gen_tcp:connect(Host,Port,[binary,{active,true},{packet,PacketLength}]).

start_raw_server(Port,Fun,Max,PacketLength)->
  Name=port_name(Port),
  case whereis(Name) of
    undefined->
      Self=self(),
      Pid=spawn_link(fun()->cold_start(Self,Port,Fun,Max,PacketLength) end),
      receive
        {Pid,ok}->
          register(Name,Pid),
          {ok,self()};
        {Pid,Error}->
          Error
      end;
    _Pid->
      {error,already_started}
  end.

stop(Port) ->
  Name=port_name(Port),
  case whereis(Name) of
    undefined->
      not_started;
    Pid->
      exit(Pid,kill),
      (catch unregister(Name)),
      stopped
  end.
children(Port)->
  port_name(Port)!{children,self()},
  receive
    {session_server,Reply}->Reply
  end.
port_name(Port)->
  list_to_atom("portServer"++integer_to_list(Port)).

cold_start(Master,Port,Fun,Max,PacketLength)->
  process_flag(trap_exit,true),
  case gen_tcp:listen(Port,[binary,{nodelay,true},{packet,PacketLength},{reuseaddr,true},{active,true}]) of
    {ok,Listen}->
      Master!{self(),ok},
      New=start_accept(Listen,Fun),
      socket_loop(Listen,New,[],Fun,Max);
    Error->
      Master!{self(),Error}
  end.

socket_loop(Listen,New,Active,Fun,Max)->
  receive
    {istarted,New}->
      Active1=[New|Active],
      possibly_start_another(false,Listen,Active1,Fun,Max);
    {'EXIT',New,_Why}->
      possibly_start_another(false,Listen,Active,Fun,Max);
    {'EXIT',Pid,_Why}->
      Active1=lists:delete(Pid,Active),
      possibly_start_another(New,Listen,Active1,Fun,Max);
    {children,From}->
      From!{session_server,Active},
      socket_loop(Listen,New,Active,Fun,Max);
    _Other->
      socket_loop(Listen,New,Active,Fun,Max)
  end.

possibly_start_another(New,Listen,Active,Fun,Max)
  when is_pid(New)->
    socket_loop(Listen,New,Active,Fun,Max);
possibly_start_another(false,Listen,Active,Fun,Max)->
  case length(Active) of
    N when N<Max ->
      New=start_accept(Listen,Fun),
      socket_loop(Listen,New,Active,Fun,Max);
    _->
      socket_loop(Listen,false,Active,Fun,Max)
  end.

start_accept(Listen,Fun)->
  S=self(),
  spawn_link(fun()->start_child(S,Listen,Fun) end).

start_child(Parent,Listen,Fun)->
  case gen_tcp:accept(Listen) of
    {ok,Socket}->
      Parent!{istarted,self()},
      inet:setopts(Socket,[{packet,4},binary,{nodelay,true},{active,true}]),
      process_flag(trap_exit,true),
      case (catch Fun(socket)) of
        {"EXIT",normal}->
          true;
        {'EXIT',Why}->
          io:format("port process dies with exit: ~p ~n",[Why]);
        _->
          true
      end
  end.

