%%%-------------------------------------------------------------------
%%% @author mtcle@126.com
%%% @copyright (C) 2020, 
%%% @doc
%%% erlang中的record有点类似c中的结构体，使用-record声明
%%% @end
%%% Created : 16. 9月 2020 14:39
%%%-------------------------------------------------------------------
-module(mod_record).
-author("mtcle@126.com").


%% 1、record 声明,第一个参数就是record的名称，第二个参数是整个tuple元组，
%% tuple里面包含field和field的值,age没默认值，其他都有默认值。
%%
%% 2、使用record，直接使用#re_person 即可
%% 3、record的字段数量是不能改变的，一旦声明过就是固定顺序，固定数量了。
%% 4、record 一般声明到头文件中,使用的地方include一下对应的头文件即可,所以改造一下该mod
%%-record(re_person,{name="mtcle",age,email="mtcle@126.com",address="china.ha.zz"}).

-include("h_record.hrl").

%% API
-export([useRecord/0]).

useRecord()->
  Year2020=#re_person{},%% 直接使用默认声明的话，age filed字段为空，undefined
  %% {re_person,"mtcle",undefined,"mtcle@126.com","china.ha.zz"}
  io:format("2020year mtcle's desc ~p~n",[Year2020]),
  Year2021=#re_person{age=25},%% 匹配设置age=25
  %% {re_person,"mtcle",25,"mtcle@126.com","china.ha.zz"}
  io:format("2021year mtcle's desc ~p~n",[Year2021]),
  Year2022=#re_person{address="pds"},%% address=“pds”
  %% Year2022= {re_person,"mtcle",undefined,"mtcle@126.com","pds"}，可见record并没有保存上面age=25的状态
  io:format("2021year mtcle's desc ~p~n",[Year2022]).