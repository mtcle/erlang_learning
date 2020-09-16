%%%-------------------------------------------------------------------
%%% @author mtcle@126.com
%%% @copyright (C) 2020, 
%%% @doc
%%%
%%% @end
%%% Created : 16. 9月 2020 15:56
%%%-------------------------------------------------------------------
-module(demo_app).
-author("mtcle@126.com").


-behavior(application).

-include("define_config.hrl").

%% API
-export([start/0,start/2,stop/1]).

start()->
  application:start(server)
.

start(_Type,[A])->
  utils:debug("Server starting...~p~n",[A]),
  utils:debug("Server starting...~n",[]),

  {ok,Pid}=demo_sup:start_link(),
  utils:debug("Server started in pid:~p~n",[Pid]),
  {ok,Pid}.

stop(_State)->
  ?Debug("demo_app is stoped!").