%%%-------------------------------------------------------------------
%%% @author mtcle@126.com
%%% @copyright (C) 2020, 
%%% @doc
%%% @end
%%%-------------------------------------------------------------------
-module(myapp).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
  myapp_sup:start_link().

stop(_State) ->
  ok.
