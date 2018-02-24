FROM jdeathe/centos-ssh
RUN yum install -y wget
RUN mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
RUN wget http://mirrors.163.com/.help/CentOS6-Base-163.repo && mv /CentOS6-Base-163.repo /etc/yum.repos.d/
RUN mv /etc/yum.repos.d/CentOS6-Base-163.repo /etc/yum.repos.d/CentOS-Base.repo
RUN yum clean all
RUN yum makecache
RUN yum update -y
RUN yum install httpd -y
RUN mkdir /var/tmp/jdk
RUN wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie"  -P /var/tmp/jdk http://download.oracle.com/otn-pub/java/jdk/8u161-b12/2f38c3b165be4555a1fa6e98c45e0808/jdk-8u161-linux-x64.tar.gz
RUN tar xzf /var/tmp/jdk/jdk-8u161-linux-x64.tar.gz -C /var/tmp/jdk && rm -rf /var/tmp/jdk/jdk-8u161-linux-x64.tar.gz
RUN mkdir /var/tmp/tomcat
RUN wget -P  /var/tmp/tomcat http://mirrors.tuna.tsinghua.edu.cn/apache/tomcat/tomcat-7/v7.0.85/bin/apache-tomcat-7.0.85.tar.gz
RUN tar xzf /var/tmp/tomcat/apache-tomcat-7.0.85.tar.gz -C /var/tmp/tomcat && rm -rf /var/tmp/tomcat/apache-tomcat-7.0.85.tar.gz
RUN echo > ./var/tmp/tomcat/apache-tomcat-7.0.85/conf/tomcat-users.xml
RUN echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" >> ./var/tmp/tomcat/apache-tomcat-7.0.85/conf/tomcat-users.xml
RUN echo "<tomcat-users>" >> ./var/tmp/tomcat/apache-tomcat-7.0.85/conf/tomcat-users.xml
RUN echo " <role rolename=\"manager-gui\"/>" >> ./var/tmp/tomcat/apache-tomcat-7.0.85/conf/tomcat-users.xml
RUN echo " <role rolename=\"admin-gui\"/>" >> ./var/tmp/tomcat/apache-tomcat-7.0.85/conf/tomcat-users.xml
RUN echo " <user username=\"admin\" password=\"admin\" roles=\"manager-gui,admin-gui\"/>" >> ./var/tmp/tomcat/apache-tomcat-7.0.85/conf/tomcat-users.xml
RUN echo "</tomcat-users>" >> ./var/tmp/tomcat/apache-tomcat-7.0.85/conf/tomcat-users.xml
RUN sed -i /^$/d /var/tmp/tomcat/apache-tomcat-7.0.85/conf/tomcat-users.xml
ENV JAVA_HOME /var/tmp/jdk/jdk1.8.0_161
ENV CATALINA_HOME /var/tmp/tomcat/apache-tomcat-7.0.85
ENV PATH $PATH:$JAVA_HOME/bin:$CATALINA_HOME/bin
EXPOSE 8080
EXPOSE 80
CMD ["./var/tmp/tomcat/apache-tomcat-7.0.85/bin/catalina.sh","run"] && exec /usr/sbin/apachectl -D FOREGROUND



docker build -t zhouhua/tomcat:1.0 .


docker run -it -p 12345:8080 --name=tomcat-test tomcat

http://blog.csdn.net/bingoxubin/article/details/78720976



docker run -it -p 10022:22 -p 12345:8080 -p 12346:80 --name=webapps zhouhua/webapps:1.0