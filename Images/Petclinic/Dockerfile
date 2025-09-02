# Stage 1: Build
FROM maven:3.9.6-eclipse-temurin-17 AS builder
WORKDIR /app
RUN git clone https://github.com/spring-projects/spring-petclinic.git .
RUN mvn package -DskipTests

# Stage 2: Runtime
FROM openjdk:17-jdk-slim
WORKDIR /app
COPY --from=builder /app/target/spring-petclinic-*.jar app.jar
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]
