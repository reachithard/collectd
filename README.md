# collectd
## 说明   
本仓库是collectd的镜像仓库，源地址为[collectd](https://github.com/collectd/collectd)。   
本项目做的修改如下:   
* 重写了collectd的构建框架(进行中，主要脚本在cmake文件夹下)。
* 增加了进程插件依赖地址为[capture](https://github.com/reachithard/capture)
* 移动原有[README](./docs/README)到docs文件夹下
* types.db新增了capture及pid类型

## 资源监控及其告警
将作为资源监控及其告警的数据采集端。