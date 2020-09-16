%%%-------------------------------------------------------------------
%%% @author mtcle@126.com
%%% @copyright (C) 2020, 
%%% @doc
%%%
%%% @end
%%% Created : 16. 9月 2020 18:29
%%%-------------------------------------------------------------------
-module(app_math).
-author("mtcle@126.com").

%% API
-export([start_math/0]).
start_math()->
  lib_chan:start_server("./conf"),
  case lib_chan:connect("localhost",2333,math,"1234",{yes,go}) of
    {ok,S}->
      lib_chan:rpc(S,{sum,3,5});
   _->
      io:format("start error！！")
  end.
