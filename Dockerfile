#基础镜像使用tomcat，这样可以免于设置java环境
FROM daocloud.io/library/tomcat:7.0.77-jre8

#作者
MAINTAINER wuwf <272551766@qq.com>

#定义工作目录
ENV WORK_PATH /usr/local/work

RUN wget http://mirrors.tuna.tsinghua.edu.cn/apache/kafka/1.0.0/kafka_2.12-1.0.0.tgz

#定义kafka文件夹名称
ENV KAFKA_PACKAGE_NAME kafka_2.12-1.0.0

#创建工作目录
RUN mkdir -p $WORK_PATH

#把启动server的shell复制到工作目录
COPY ./start_server.sh $WORK_PATH/

#把kafka压缩文件复制到工作目录
RUN mv $KAFKA_PACKAGE_NAME.tgz $WORK_PATH/

#解压缩
RUN tar -xvf $WORK_PATH/$KAFKA_PACKAGE_NAME.tgz -C $WORK_PATH/

#删除压缩文件
RUN rm $WORK_PATH/$KAFKA_PACKAGE_NAME.tgz

#执行sed命令修改文件，将连接zk的ip改为link参数对应的zookeeper容器的别名
#RUN sed -i 's/zookeeper.connect=localhost:2181/zookeeper.connect=zkhost:2181/g' $WORK_PATH/$KAFKA_PACKAGE_NAME/config/server.properties
RUN $WORK_PATH/$KAFKA_PACKAGE_NAME/bin/zookeeper-server-start.sh $WORK_PATH/$KAFKA_PACKAGE_NAME/config/zookeeper.properties &

#给shell赋予执行权限
RUN chmod a+x $WORK_PATH/start_server.sh
