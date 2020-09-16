%%%-------------------------------------------------------------------
%%% @author mtcle@126.com
%%% @copyright (C) 2020, 
%%% @doc
%%%
%%% @end
%%% Created : 16. 9月 2020 15:12
%%%-------------------------------------------------------------------
-module(mod_define).
-author("mtcle@126.com").

-include("define_config.hrl").
%% API
-export([test_define/0,test/0]).

test_define()->
  CodePerson={get_username(),get_useremail()},
  ?Debug(CodePerson),
  io:format("current coder info is:~p~n",[CodePerson]).

test()->
  Test={1,2,3},
  ?VALUE(Test).



get_username()->
  ?CODE_USER_NAME.

get_useremail()->
  ?CODE_USER_EMAIL.