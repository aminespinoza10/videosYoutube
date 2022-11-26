FROM mcr.microsoft.com/openjdk/jdk:17-ubuntu as base

EXPOSE 8080

ADD target/spring-boot-docker.jar spring-boot-docker.jar

ENTRYPOINT [ "java", "-jar", "/spring-boot-docker.jar" ]
