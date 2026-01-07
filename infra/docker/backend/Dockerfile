# Build stage
FROM eclipse-temurin:21-jdk-alpine AS build

WORKDIR /workspace/app

# Copy Maven wrapper and pom.xml first for better layer caching
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .

# Make mvnw executable
RUN chmod +x mvnw

# Download dependencies (this layer will be cached if pom.xml doesn't change)
RUN ./mvnw dependency:go-offline -B

# Copy source code
COPY src src

# Build application
RUN ./mvnw clean package -DskipTests
RUN mkdir -p target/dependency && (cd target/dependency; jar -xf ../*.jar)

# Runtime stage
FROM eclipse-temurin:21-jre-alpine

# Install curl for health checks
RUN apk add --no-cache curl

# Create non-root user
RUN addgroup -g 1001 -S tasbal && adduser -u 1001 -S tasbal -G tasbal

WORKDIR /app

# Copy dependencies and application from build stage
ARG DEPENDENCY=/workspace/app/target/dependency
COPY --from=build ${DEPENDENCY}/BOOT-INF/lib /app/lib
COPY --from=build ${DEPENDENCY}/META-INF /app/META-INF
COPY --from=build ${DEPENDENCY}/BOOT-INF/classes /app

# Change ownership
RUN chown -R tasbal:tasbal /app

USER tasbal

EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD curl -f http://localhost:8080/actuator/health || exit 1

ENTRYPOINT ["java", "-cp", "app:app/lib/*", "com.tasbal.backend.TasbalBackendApplication"]