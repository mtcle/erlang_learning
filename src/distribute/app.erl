%%%-------------------------------------------------------------------
%%% @author Lenovo
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%% 这是一个分布式的应用app，本身就是个 set、get，可以在两个不同节点上面验证
%%% 1、分别启动两个不同节点：erl -sname server1 -setcookie myCookies 和 erl -sname server2 -setcookie myCookies ,注意cookie要相同
%%% 2、在一个节点调用set：rpc:call(server1@YAXINYA,app,store,[mtcle,yxy])
%%% 3、在一个节点调用get: rpc:call(server1@YANXINYA,app,lookup,[mtcle])
%%% 好简单的说
%%% @end
%%% Created : 14. 9月 2020 11:06
%%%-------------------------------------------------------------------
-module(app).
-author("Lenovo").

%% API
-export([start/0,store/2,lookup/1]).
start()->register(app,spawn(fun()->loop() end)).

store(Key,Value)->rpc({store,Key,Value}).

lookup(Key)->rpc({lookup,Key}).

rpc(Q)->
  app!{self(),Q},
  receive
    {app,Replay}->
      Replay
  end.

loop()->
  receive
    {From,{store,Key,Value}}->
      put(Key,{ok,Value}),
      From!{app,true},
      loop();
    {From,{lookup,Key}}->
      From!{app,get(Key)},
      loop()
  end.

