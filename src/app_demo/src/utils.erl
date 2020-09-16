%%%-------------------------------------------------------------------
%%% @author mtcle@126.com
%%% @copyright (C) 2020, 
%%% @doc
%%%
%%% @end
%%% Created : 16. 9月 2020 16:00
%%%-------------------------------------------------------------------
-module(utils).
-author("mtcle@126.com").

%% API
-export([debug/2]).
debug(F,Args)->
  %% 可以在程序内使用application:get_env/2获取这里定义的变量
  {ok,LogPath}=application:get_env(sasl,error_logger_mf_dir),
  File=LogPath++"/debug.log",
  {ok,Steam}=file:open(File,[write,append]),
  io:format(Steam,F,Args),
  file:close(Steam).