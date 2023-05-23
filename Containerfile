FROM eclipse-temurin:11-jdk-jammy

ENV JAVA_OPTS=""
ENV KUBERNETES_NAMESPACE="default"
WORKDIR /deployments
COPY conf/ /deployments/conf/
ADD tomcat.deploy /deployments/tomcat
ADD tomcat.jar /deployments
ADD build/libs/tomcat-sessions-0.0.1-SNAPSHOT.war /deployments/webapps/app.war

EXPOSE 4000
EXPOSE 8080
ENTRYPOINT ["bash", "tomcat"]