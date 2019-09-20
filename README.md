kafka_exporter
==============

Kafka exporter for Prometheus. For other metrics from Kafka, have a look at the [JMX exporter](https://github.com/prometheus/jmx_exporter).

Forked from [danielqsj/kafka_exporter](https://github.com/danielqsj/kafka_exporter)

Table of Contents
-----------------

-	[Compatibility](#compatibility)
-	[Dependency](#dependency)
-	[Download](#download)
-	[Compile](#compile)
	-	[Build Binary](#build-binary)
	-	[Build Docker Image](#build-docker-image)
-	[Run](#run)
	-	[Run Binary](#run-binary)
	-	[Run Docker Image](#run-docker-image)
-	[Flags](#flags)
    -	[Notes](#notes)
-	[Metrics](#metrics)
	-	[Brokers](#brokers)
	-	[Topics](#topics)
	-	[Consumer Groups](#consumer-groups)
-	[Grafana Dashboard](#grafana-dashboard)	
-   [Contribute](#contribute)
-   [Donation](#donation)
-   [License](#license)

Compatibility
-------------

Support [Apache Kafka](https://kafka.apache.org) version 0.10.1.0 (and later).

Dependency
----------

-	[Prometheus](https://prometheus.io)
-	[Sarama](https://shopify.github.io/sarama)
-	[Golang](https://golang.org)

Compile
-------

### Build Binary

```shell
make
```

### Build Docker Image

```shell
make docker
```

Run
---

### Run Binary

```shell
kafka_exporter --kafka.server=kafka:9092 [--kafka.server=another-server ...]
```

### Run Docker Image

```
docker run -ti --rm -p 9090:9090 kafka-exporter --kafka.server=kafka:9092 [--kafka.server=another-server ...]
```

Flags
-----

This image is configurable using different flags

| Flag name                    | Environment Variable                        | Default    | Description                                                                                         |
| ---------------------------- | ------------------------------------------- | ---------- | --------------------------------------------------------------------------------------------------- |
| kafka.server                 | KAFKA_EXPORTER_KAFKA_SERVER                 | kafka:9092 | Addresses (host:port) of Kafka server                                                               |
| kafka.version                | KAFKA_EXPORTER_KAFKA_VERSION                | 1.0.0      | Kafka broker version                                                                                |
| sasl.enabled                 | KAFKA_EXPORTER_SASL_ENABLED                 | false      | Connect using SASL/PLAIN                                                                            |
| sasl.handshake               | KAFKA_EXPORTER_SASL_HANDSHAKE               | true       | Only set this to false if using a non-Kafka SASL proxy                                              |
| sasl.username                | KAFKA_EXPORTER_SASL_USERNAME                |            | SASL user name                                                                                      |
| sasl.password                | KAFKA_EXPORTER_SASL_PASSWORD                |            | SASL user password                                                                                  |
| tls.enabled                  | KAFKA_EXPORTER_TLS_ENABLED                  | false      | Connect using TLS                                                                                   |
| tls.ca-file                  | KAFKA_EXPORTER_TLS_CA_FILE                  |            | The optional certificate authority file for TLS client authentication                               |
| tls.cert-file                | KAFKA_EXPORTER_TLS_CERT_FILE                |            | The optional certificate file for client authentication                                             |
| tls.key-file                 | KAFKA_EXPORTER_TLS_KEY_FILE                 |            | The optional key file for client authentication                                                     |
| tls.insecure-skip-tls-verify | KAFKA_EXPORTER_TLS_INSECURE_SKIP_TLS_VERIFY | false      | If true, the server's certificate will not be checked for validity                                  |
| topic.filter                 | KAFKA_EXPORTER_TOPIC_FILTER                 | .*         | Regex that determines which topics to collect                                                       |
| group.filter                 | KAFKA_EXPORTER_GROUP_FILTER                 | .*         | Regex that determines which consumer groups to collect                                              |
| web.listen-address           | KAFKA_EXPORTER_WEB_LISTEN_ADDRESS           | :9090      | Address to listen on for web interface and telemetry                                                |
| web.telemetry-path           | KAFKA_EXPORTER_WEB_TELEMETRY_PATH           | /metrics   | Path under which to expose metrics                                                                  |
| log.level                    | KAFKA_EXPORTER_LOG_LEVEL                    | info       | Only log messages with the given severity or above. Valid levels: [debug, info, warn, error, fatal] |
| log.enable-sarama            | KAFKA_EXPORTER_LOG_ENABLE_SARAMA            | false      | Turn on Sarama logging                                                                              |

### Notes

Boolean values are uniquely managed by [Kingpin](https://github.com/alecthomas/kingpin/blob/master/README.md#boolean-values). Each boolean flag will have a negative complement:
`--<name>` and `--no-<name>`.

For example:

If you need to disable `sasl.handshake`, you could add flag `--no-sasl.handshake`

Metrics
-------

Documents about exposed Prometheus metrics.

For details on the underlying metrics please see [Apache Kafka](https://kafka.apache.org/documentation).

### Brokers

**Metrics details**

| Name            | Exposed informations                   |
| --------------- | -------------------------------------- |
| `kafka_brokers` | Number of Brokers in the Kafka Cluster |

**Metrics output example**

```txt
# HELP kafka_brokers Number of Brokers in the Kafka Cluster.
# TYPE kafka_brokers gauge
kafka_brokers 3
```

### Topics

**Metrics details**

| Name                                               | Exposed informations                                |
| -------------------------------------------------- | --------------------------------------------------- |
| `kafka_topic_partitions`                           | Number of partitions for this Topic                 |
| `kafka_topic_partition_current_offset`             | Current Offset of a Broker at Topic/Partition       |
| `kafka_topic_partition_oldest_offset`              | Oldest Offset of a Broker at Topic/Partition        |
| `kafka_topic_partition_in_sync_replica`            | Number of In-Sync Replicas for this Topic/Partition |
| `kafka_topic_partition_leader`                     | Leader Broker ID of this Topic/Partition            |
| `kafka_topic_partition_leader_is_preferred`        | 1 if Topic/Partition is using the Preferred Broker  |
| `kafka_topic_partition_replicas`                   | Number of Replicas for this Topic/Partition         |
| `kafka_topic_partition_under_replicated_partition` | 1 if Topic/Partition is under Replicated            |

**Metrics output example**

```txt
# HELP kafka_topic_partitions Number of partitions for this Topic
# TYPE kafka_topic_partitions gauge
kafka_topic_partitions{topic="__consumer_offsets"} 50

# HELP kafka_topic_partition_current_offset Current Offset of a Broker at Topic/Partition
# TYPE kafka_topic_partition_current_offset gauge
kafka_topic_partition_current_offset{partition="0",topic="__consumer_offsets"} 0

# HELP kafka_topic_partition_oldest_offset Oldest Offset of a Broker at Topic/Partition
# TYPE kafka_topic_partition_oldest_offset gauge
kafka_topic_partition_oldest_offset{partition="0",topic="__consumer_offsets"} 0

# HELP kafka_topic_partition_in_sync_replica Number of In-Sync Replicas for this Topic/Partition
# TYPE kafka_topic_partition_in_sync_replica gauge
kafka_topic_partition_in_sync_replica{partition="0",topic="__consumer_offsets"} 3

# HELP kafka_topic_partition_leader Leader Broker ID of this Topic/Partition
# TYPE kafka_topic_partition_leader gauge
kafka_topic_partition_leader{partition="0",topic="__consumer_offsets"} 0

# HELP kafka_topic_partition_leader_is_preferred 1 if Topic/Partition is using the Preferred Broker
# TYPE kafka_topic_partition_leader_is_preferred gauge
kafka_topic_partition_leader_is_preferred{partition="0",topic="__consumer_offsets"} 1

# HELP kafka_topic_partition_replicas Number of Replicas for this Topic/Partition
# TYPE kafka_topic_partition_replicas gauge
kafka_topic_partition_replicas{partition="0",topic="__consumer_offsets"} 3

# HELP kafka_topic_partition_under_replicated_partition 1 if Topic/Partition is under Replicated
# TYPE kafka_topic_partition_under_replicated_partition gauge
kafka_topic_partition_under_replicated_partition{partition="0",topic="__consumer_offsets"} 0
```

### Consumer Groups

**Metrics details**

| Name                                 | Exposed informations                                          |
| ------------------------------------ | ------------------------------------------------------------- |
| `kafka_consumergroup_current_offset` | Current Offset of a ConsumerGroup at Topic/Partition          |
| `kafka_consumergroup_lag`            | Current Approximate Lag of a ConsumerGroup at Topic/Partition |

**Metrics output example**

```txt
# HELP kafka_consumergroup_current_offset Current Offset of a ConsumerGroup at Topic/Partition
# TYPE kafka_consumergroup_current_offset gauge
kafka_consumergroup_current_offset{consumergroup="KMOffsetCache-kafka-manager-3806276532-ml44w",partition="0",topic="__consumer_offsets"} -1

# HELP kafka_consumergroup_lag Current Approximate Lag of a ConsumerGroup at Topic/Partition
# TYPE kafka_consumergroup_lag gauge
kafka_consumergroup_lag{consumergroup="KMOffsetCache-kafka-manager-3806276532-ml44w",partition="0",topic="__consumer_offsets"} 1
```

License
-------

Code is licensed under the [Apache License 2.0](https://github.com/danielqsj/kafka_exporter/blob/master/LICENSE).
