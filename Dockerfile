FROM eclipse-temurin:17-jdk-focal as base
#ENV PORT=8080
WORKDIR /app
COPY .mvn/ .mvn
COPY mvnw pom.xml ./
RUN chmod +x mvnw
RUN ./mvnw dependency:resolve
#RUN ./mvnw dependency:go-offline
COPY src ./src

FROM base as testing
RUN ["./mvnw", "test"]

FROM base as development
#CMD ["./mvnw", "spring-boot:run -Dspring-boot.run.arguments='http://10.0.114.100:8080, http://10.0.44.53:8080, http://10.0.55.15:8080'"]
CMD java -jar ./orders-service-example 0.0.1-SNAPSHOT.jar http://10.0.114.100:8080 http://10.0.44.53:8080 http://10.0.55.15:8080

FROM base as staging
#CMD ["./mvnw", "spring-boot:run -Dspring-boot.run.arguments='http://10.0.114.100:8080, http://10.0.44.53:8080, http://10.0.55.15:8080'"]
CMD java -jar ./orders-service-example 0.0.1-SNAPSHOT.jar http://10.0.114.100:8080 http://10.0.44.53:8080 http://10.0.55.15:8080

FROM base as production
#EXPOSE 8080
#CMD ["./mvnw", "spring-boot:run -Dspring-boot.run.arguments='http://10.0.114.100:8080, http://10.0.44.53:8080, http://10.0.55.15:8080'"]
CMD java -jar ./orders-service-example 0.0.1-SNAPSHOT.jar http://10.0.114.100:8080 http://10.0.44.53:8080 http://10.0.55.15:8080
