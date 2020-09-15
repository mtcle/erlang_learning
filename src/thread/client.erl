%%%-------------------------------------------------------------------
%%% @author Lenovo
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. 9月 2020 9:05
%%%-------------------------------------------------------------------
-module(client).
-author("Lenovo").

%% API
-export([useSum/2,useSum2/2,useArea/0]).
useSum(X, Y) ->
%%  1、创建一个进程，以module和方法为参数变量，得到对应的pid
  Pid = spawn(server, loop, []),
%%  2、通过对应的pid，通过！发送消息，对应的进程即可收到对应的消息
  Pid ! {self(),{sum, X, Y}}.

useSum2(X,Y)->
 Pid=spawn(server,loop,[]),
  server:rpc(Pid,{X,Y}).

useArea()->
  Pid=server:start(),
  server:area(Pid,{sum,10,10}),
  server:area(Pid,{squ,10}).