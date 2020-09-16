%%%-------------------------------------------------------------------
%%% @author Lenovo
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. 9月 2020 15:07
%%%-------------------------------------------------------------------
-module(mod_cb_b).
-author("Lenovo").

%% API
-export([processMoney/1,run/0]).
processMoney(Age)->
  Total=Age*100,
  io:format("total~p~n",[Total]).

processName(Callback,Name)->
  io:format("hello ~p~n",[Name]),
  Callback(mod_cb_a:get_age()),
  io:format("--processName---~p~n",[Name])
.

run()->
  processMoney(mod_cb_a:get_age()),
  SuccessCb=fun(Name)->
    io:format("goted name is~p he is ~p years old~n",[Name,mod_cb_a:get_age()])
            end,
  processName(SuccessCb,mod_cb_a:get_name()).