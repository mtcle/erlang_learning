%%%-------------------------------------------------------------------
%%% @author mtcle@126.com
%%% @copyright (C) 2020, 
%%% @doc
%%%
%%% @end
%%% Created : 16. 9月 2020 16:10
%%%-------------------------------------------------------------------
-module(demo).
-author("mtcle@126.com").

%% API
-export([star]).

start()->
  utils:debug("demo mod is started~~~n",[]),
  {ok,self()}.