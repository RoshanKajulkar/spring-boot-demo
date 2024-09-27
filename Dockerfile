# Importing JDK and copying required files
FROM openjdk:19-jdk AS build
WORKDIR /app

# Debug: List all files before copying
RUN ls -a

COPY pom.xml .
COPY src src

# Debug: List all files after copying pom.xml and src
RUN ls -a

# Copy Maven wrapper
COPY mvnw .
COPY .mvn .mvn

# Debug: List all files after copying .mvn and mvnw
RUN ls -a

# Set execution permission for the Maven wrapper
RUN chmod +x ./mvnw
RUN ./mvnw clean package -DskipTests

# Stage 2: Create the final Docker image using OpenJDK 19
FROM openjdk:19-jdk
VOLUME /tmp

# Copy the JAR from the build stage
COPY --from=build /app/target/*.jar app.jar
ENTRYPOINT ["java","-jar","/app.jar"]
EXPOSE 8080
