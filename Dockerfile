# Use official Eclipse Temurin OpenJDK 21 image
FROM eclipse-temurin:21-jdk-jammy

# Set working directory inside container
WORKDIR /app

# Copy the Spring Boot jar into the container
COPY target/devops-integration.jar devops-integration.jar

# Expose the port your app runs on
EXPOSE 8080

# Run the Spring Boot application
ENTRYPOINT ["java", "-jar", "/app/devops-integration.jar"]
