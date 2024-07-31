From tomcat:8
LABEL Training=Kols
ENV NEXUS_URL=http://3.110.42.85:8081/repository/maven-releases/com/example/my-webapp/1.0/my-webapp-1.0.war
RUN apt-get update && apt-get install -y wget
RUN wget -O /usr/local/tomcat/webapps/my-webapp.war ${NEXUS_URL}
EXPOSE 9091
ENTRYPOINT ["catalina.sh", "run"]
