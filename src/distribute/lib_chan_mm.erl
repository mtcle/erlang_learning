%%%-------------------------------------------------------------------
%%% @author Lenovo
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%% 中间人模块，发送控制进程
%%% @end
%%% Created : 14. 9月 2020 17:24
%%%-------------------------------------------------------------------
-module(lib_chan_mm).
-author("Lenovo").

%% API
-export([loop/2,send/2,close/1,controller/2,set_trace/2,trace_with_tag/2]).
send(Pid,Term)->
  Pid!{send,Term}.

close(Pid)->
  Pid!close.

controller(Pid,Pid1)->
  Pid!{setController,Pid1}.

set_trace(Pid,X)->
  Pid!{trace,X}.

trace_with_tag(Pid,Tag)->
  set_trace(Pid,{true,fun(Msg)->io:format("MM：~p~p~n",[Tag,Msg]) end}).

loop(Socket,Pid)->
  process_flag(trap_exit,true),
  loop1(Socket,Pid,false).

loop1(Socket,Pid,Trace)->
  receive
    {tcp,Socket,Bin}->
      Term=binary_to_term(Bin),
      trace_it(Trace,{socketReceived,Term}),
      Pid!{chan,self(),Term},
      loop1(Socket,Pid,Trace);
    {tcp_closed,Socket}->
      trace_it(Trace,socketClosed),
      Pid!{chan_closed,self()};
    {'EXIT',Pid,Why}->
      trace_it(Trace,{controllingProcessExit,Why}),
      gen_tcp:close(Socket);
    {setController,Pid1}->
      trace_it(Trace,{changedController,Pid}),
      loop1(Socket,Pid1,Trace);
    {trace,Trace1}->
      trace_it(Trace,{setTrace,Trace1}),
      loop1(Socket,Pid,Trace);
    close->
      trace_it(Trace,closeByClient),
      gen_tcp:close(Socket);
    {send,Term}->
      trace_it(Trace,{sendingMessage,Term}),
      gen_tcp:send(Socket,term_to_binary(Term)),
      loop1(Socket,Pid,Trace);
    UUg->
      io:format("lib_chan_mm:-----error-----~ts~n",[UUg]),
      loop1(Socket,Pid,Trace)
  end.

trace_it(false,_)->void;
trace_it({true,F},M)->F(M).