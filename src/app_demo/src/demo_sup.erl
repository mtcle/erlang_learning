%%%-------------------------------------------------------------------
%%% @author mtcle@126.com
%%% @copyright (C) 2020, 
%%% @doc
%%%
%%% @end
%%% Created : 16. 9月 2020 16:06
%%%-------------------------------------------------------------------
-module(demo_sup).
-author("mtcle@126.com").

-behavior(supervisor).

%% API
-export([start_link/0,init/1]).


start_link()->
  supervisor:start_link({local,?MODULE},?MODULE,[]).

init([])->
  {ok,{{one_for_one,3,10},[{demo,{demo,start,[]},permanent,1000,worker,[]}]}}.
