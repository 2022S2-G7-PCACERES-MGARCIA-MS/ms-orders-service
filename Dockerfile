FROM eclipse-temurin:17-jdk-focal as base
#ENV PORT=8080
WORKDIR /app
COPY .mvn/ .mvn
COPY mvnw pom.xml ./
RUN chmod +x mvnw
RUN ./mvnw dependency:resolve
#RUN ./mvnw dependency:go-offline
COPY src ./src

# args[0]: setPaymentsServiceUrl
# args[0]: setShippingServiceUrl
# args[0]: setProductsServiceUrl

FROM base as testing
RUN ["./mvnw", "test"]

FROM base as localhost
RUN  ./mvnw package
CMD java -jar target/orders-service-example-0.0.1-SNAPSHOT.jar http://172.17.0.4:8083 http://172.17.0.2:8082 http://172.17.0.3:8081

FROM base as development
RUN  ./mvnw package
# CMD java -jar target/orders-service-example-0.0.1-SNAPSHOT.jar http://10.0.103.109:8080 http://10.0.5.185:8080 http://10.0.125.150:8080
CMD java -jar target/orders-service-example-0.0.1-SNAPSHOT.jar http://10.0.80.60:8080 http://10.0.33.220:8080 http://10.0.32.192:8080

FROM base as staging
RUN  ./mvnw package
CMD java -jar target/orders-service-example-0.0.1-SNAPSHOT.jar http://10.0.114.100:8080 http://10.0.44.53:8080 http://10.0.55.15:8080

FROM base as production
#EXPOSE 8080
RUN  ./mvnw package
CMD java -jar target/orders-service-example-0.0.1-SNAPSHOT.jar http://10.0.114.100:8080 http://10.0.44.53:8080 http://10.0.55.15:8080