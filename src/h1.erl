%%%-------------------------------------------------------------------
%%% @author Lenovo
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%% @end
%%%-------------------------------------------------------------------
-module(h1).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
  test1:ppp(mtcle).

stop(_State) ->
  ok.
