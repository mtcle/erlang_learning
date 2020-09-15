%%%-------------------------------------------------------------------
%%% @author Lenovo
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. 9月 2020 9:04
%%%-------------------------------------------------------------------
-module(server).
-author("Lenovo").

%% API
-export([start/0,area/2,loop/0]).
start()->
  spawn(server,loop,[]).
area(Pid,What)->
  Pid!{self(),What}.

rpc(Pid,Request)->
  Pid!{self(),Request},
  receive
    {Pid,Response}->
      Response
  end.
loop()->
  receive
%%    {sum,X,Y}->
%%      io:format("sum is ~p ~n",[X+Y]),
%%      loop()

    {From,{sum,X,Y}}->
      From!{self(),X+Y},
      io:format("sum is ~p~n",[X+Y]),%%这里是逗号
      loop();%%这里是分号
    {From,{squ,X}}->
      From!{self(),X*X},
      io:format("square is ~p~n",[X*X]),
      loop()%% 这里不写分号
  end.%% 一个函数结尾要有句号