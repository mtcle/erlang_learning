%%%-------------------------------------------------------------------
%%% @author Lenovo
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. 9月 2020 14:11
%%%-------------------------------------------------------------------
-module(mod_server).
-author("Lenovo").

%% API
-export([start_me/3]).
start_me(Name,_ArgC,_ArgS)->
  loop(Name).
loop(Name)->
  receive
    {chan,Name,{store,K,V}}->
      app:store(K,V),
      loop(Name);
    {chan,Name,{lookup,K}}->
      Name!{send,app:lookup(K)},
      loop(Name);
    {chan_closed,Name}->
      true
  end.