cd config
erl -name YANXINYA@192.168.3.101 -setcookie mycookie -boot start_sasl -noshell -config config -pa ../ebin/ -s demo_app start

#   -noshell 禁止输入
#   -config xxx 加载文件名为xxx.config的配置
#   -pa 指定目录
#   -s xxx yyy 启动xxx模块的yyy函数