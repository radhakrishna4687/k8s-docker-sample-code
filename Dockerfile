FROM ubuntu:latest
ENV TOMCAT_VERSION=8.5.50

#Install tomcat8
RUN wget --quiet --no-cookies https://archive.apache.org/dist/tomcat/tomcat-8/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz -O /tmp/tomcat.tar.gz

RUN cd /tmp && tar xvfz tomcat.tar.gz
#RUN cd /usr/local/tomcat/
RUN cp -Rv /tmp/apache-tomcat-8.5.50/* /usr/local/tomcat/

#PORT EXPOSE
EXPOSE 8080
WORKDIR /home/samplecode/${GITHUB_BRANCH}/target/
RUN cp  /var/lib/jenkins/workspace/artifacts-upload-s3-pipeline/target/*.war /usr/local/tomcat/webapps/app.war

RUN cd /usr/local/tomcat/conf
RUN sed -i '/<\/tomcat-users>/ i\  <user username="tomcat" password="tomcat" roles="manager-gui"/>' /usr/local/tomcat/conf/tomcat-users.xml
RUN cd /usr/local/tomcat/bin && \
    ./shutdown.sh && \
    ./startup.sh;

CMD ["/usr/local/tomcat/bin/catalina.sh", "run" ]
