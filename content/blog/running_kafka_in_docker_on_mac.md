---
title: "Running Kafka in Docker on Mac"
date: 2018-06-01T10:16:26-05:00
---

Running Confluent kafka stack in docker on macOS is little bit hacky. Confluent doesn't support docker on macOS yet. 
But here is how I made it work on my local macOS. I am using a docker compose file and it brings up a single node/single broker kafka cluster.

1. Save the below file to `docker-compose.yml` file on your local.

```
---
version: '2'

services:
  zookeeper:
    image: confluentinc/cp-zookeeper:latest
    ports:
      - 2181:2181
    environment:
      ZOOKEEPER_CLIENT_PORT: 2181
      ZOOKEEPER_TICK_TIME: 2000
    extra_hosts:
      - "moby:127.0.0.1"
      - "localhost: 127.0.0.1"

  kafka:
    image: confluentinc/cp-kafka:latest
    hostname: kafka-host
    ports:
      - 9092:9092
    depends_on:
      - zookeeper
    environment:
      KAFKA_BROKER_ID: 1
      KAFKA_ZOOKEEPER_CONNECT: zookeeper:2181
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://docker.for.mac.host.internal:29092
      KAFKA_AUTO_CREATE_TOPICS_ENABLE: "true"
      KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR: 1
    extra_hosts:
      - "moby:127.0.0.1"
      - "localhost: 127.0.0.1"

  schema-registry:
    image: confluentinc/cp-schema-registry:latest
    hostname: sr-host
    ports:
      - 8081:8081
    depends_on:
      - zookeeper
      - kafka
    environment:
      SCHEMA_REGISTRY_KAFKASTORE_CONNECTION_URL: zookeeper:2181
      SCHEMA_REGISTRY_HOST_NAME: sr-host
      SCHEMA_REGISTRY_LISTENERS: http://sr-host:8081
    extra_hosts:
      - "moby:127.0.0.1"
      - "localhost: 127.0.0.1"

  kafka-rest:
    image: confluentinc/cp-kafka-rest:latest
    hostname: kr-host
    ports:
      - 8082:8082
    depends_on:
      - zookeeper
      - kafka
      - schema-registry
    environment:
      KAFKA_REST_ZOOKEEPER_CONNECT: zookeeper:2181
      KAFKA_REST_LISTENERS: http://kr-host:8082
      KAFKA_REST_SCHEMA_REGISTRY_URL: http://sr-host:8081
      KAFKA_REST_HOST_NAME: kr-host
      KAFKA_REST_BOOTSTRAP_SERVERS: host.docker.internal:9092
    extra_hosts:
      - "moby:127.0.0.1"
      - "localhost: 127.0.0.1"
```

2. Run `docker-compose up`
3. Ensure the processes are running by running `docker-compose ps`
4. Add `machine_ip host.docker.internal` to your /etc/hosts file. Such as `10.0.1.1 host.docker.internal`
Note - machine ip changes with network, so update the `hosts` file accordingly

And there it is, connect on `localhost:9092` and start producing to your kafka cluster in docker.
