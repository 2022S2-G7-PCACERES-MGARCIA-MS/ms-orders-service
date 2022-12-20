FROM eclipse-temurin:17-jdk-focal as base

ARG PaymentsServiceUrl
ARG ShippingServiceUrl
ARG ProductsServiceUrl

ENV EnvPaymentsServiceUrl=${PaymentsServiceUrl}
ENV EnvShippingServiceUrl=${ShippingServiceUrl}
ENV EnvProductsServiceUrl=${ProductsServiceUrl}

RUN echo "PaymentsServiceUrl:${PaymentsServiceUrl}"
RUN echo "ShippingServiceUrl:${ShippingServiceUrl}"
RUN echo "ProductsServiceUrl:${ProductsServiceUrl}"

RUN echo "PaymentsServiceUrl:${EnvPaymentsServiceUrl}"
RUN echo "ShippingServiceUrl:${EnvShippingServiceUrl}"
RUN echo "ProductsServiceUrl:${EnvProductsServiceUrl}"

# ENV PORT=8080
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
CMD java -jar target/orders-service-example-0.0.1-SNAPSHOT.jar ${EnvPaymentsServiceUrl} ${EnvShippingServiceUrl} ${EnvProductsServiceUrl}

FROM base as development
RUN  ./mvnw package
CMD java -jar target/orders-service-example-0.0.1-SNAPSHOT.jar ${EnvPaymentsServiceUrl} ${EnvShippingServiceUrl} ${EnvProductsServiceUrl}

FROM base as staging
RUN  ./mvnw package
CMD java -jar target/orders-service-example-0.0.1-SNAPSHOT.jar ${EnvPaymentsServiceUrl} ${EnvShippingServiceUrl} ${EnvProductsServiceUrl}

FROM base as production
# EXPOSE 8080
RUN  ./mvnw package
CMD java -jar target/orders-service-example-0.0.1-SNAPSHOT.jar ${EnvPaymentsServiceUrl} ${EnvShippingServiceUrl} ${EnvProductsServiceUrl}