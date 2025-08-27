# Use OpenJDK 17 runtime
FROM openjdk:17-jdk-slim

# Expose port 8080
EXPOSE 8080

# Copy the Spring Boot jar into the container
COPY target/devops-integration.jar devops-integration.jar

# Run the application
ENTRYPOINT ["java","-jar","/devops-integration.jar"]
