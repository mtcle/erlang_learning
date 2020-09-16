%%%-------------------------------------------------------------------
%%% @author Lenovo
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. 9月 2020 14:23
%%%-------------------------------------------------------------------
-module(mod_math).
-author("Lenovo").

%% API
-export([run/3]).
run(Name,ArgC,ArgS)->
  io:format("mod_math:runing... ArgC= ~p ArgS= ~p~n",[ArgC,ArgS]),
  loop(Name).

loop(Name)->
  receive
    {chan,Name,{fact,N}}->
      Name!{send,fac(N)},
      loop(Name);
    {chan,Name,{fibon,N}}->
      Name!{send,fib(N)},
      loop(Name);
    {chan,Name,{sum,N,M}}->
      Name!{send,sum(N,M)},
      loop(Name);
    {chan_closed,Name}->
      io:format("mod_math stopping~n"),
      exit(normal)
  end.
sum(N,M)->
  M+N.


fac(0)->1;
fac(N)->N*fac(N-1).
fib(1)->1;
fib(2)->1;
fib(N)->fib(N-1)*fib(N-2).
