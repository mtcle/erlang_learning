%%%-------------------------------------------------------------------
%%% @author Lenovo
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%% 认证模块
%%% @end
%%% Created : 14. 9月 2020 17:40
%%%-------------------------------------------------------------------
-module(lib_chan_auth).
-author("Lenovo").

%% API
-export([make_challenge/0,make_response/2,is_response_correct/3]).
make_challenge()->
  random_string(25).
make_response(Change,Secret)->
  base64:encode(Change++Secret).

is_response_correct(Challenge,Response,Secret)->
  case base64:encode(Challenge++Secret) of
    Response->true;
    _->false
  end.

%% 生成一个随机字符串，包含N个长度
random_string(N)->
  random_seed(),
  random_string(N,[]).

random_string(0,D)-> D;
random_string(N,D)->
  random_string(N-1,[random:uniform(26)-1+$a|D]).
random_seed()->
  {_,_,X}=erlang:now(),
  {H,M,S}=time(),
  H1=H*X rem 32767,
  M1=M*X rem 32767,
  S1=S*X rem 32767,
  put(random_seed,{H1,M1,S1}).