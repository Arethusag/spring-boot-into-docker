# Use official maven/Java 17 image as the parent image
FROM maven:3.8.4-openjdk-17-slim as build

# Set the current working directory in the image
WORKDIR /usr/src/app

# Copy pom.xml and src directory (with all subdirectories) to the working directory
COPY pom.xml ./
COPY src ./src

# Build a jar file from the sources
RUN mvn clean package -DskipTests

# Use openjdk image for runtime
FROM openjdk:8-jdk-alpine

WORKDIR /app

# Copies the jar file from the build stage to the current location
COPY --from=build /usr/src/app/target/*.jar ./app.jar

# Run the jar file
ENTRYPOINT ["java","-jar","/app/app.jar"]