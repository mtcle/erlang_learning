{
  application,server %对应的是文件名
  ,[{description,"mtcle Server demo"},
  {vsn,"1.0a"},
  {modules,[]},
  {registered,[]},
  {applications,[kernel,stdlib,sasl]},%依赖的库
  {env,[{auther,"mtcle"}]},
  {mod,{demo_app,[12321]}},% 启动主模块
  {start_phases,[]}
]
}.