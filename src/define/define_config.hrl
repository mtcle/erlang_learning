%%%-------------------------------------------------------------------
%%% @author mtcle@126.com
%%% @copyright (C) 2020, 
%%% @doc 宏定义的使用，类似c中的宏定义，可以定义常量、定义函数等等
%%%
%%% @end
%%% Created : 16. 9月 2020 15:10
%%%-------------------------------------------------------------------
-author("mtcle@126.com").



-define(CODE_USER_NAME,"mtcle").
-define(CODE_USER_EMAIL,"mtcle@126.com").

-define(DEBUG,true).

-ifdef(DEBUG).
%% 定义宏debug日志语句
-define(Debug(X),io:format("Debug_Log_In{~p,~p}->~p~n",[?MODULE,?LINE,X])).
-else.
-define(Debug(X),true).
-endif.