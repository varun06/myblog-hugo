+++
date = "2017-01-20T05:40:02-06:00"
title = "send key value messages to kafka from console producer"
categories = ["kafka","technical"]
tags = ["kafka","bash", "blog"]

+++

[Kafka](https://kafka.apache.org) provides [kafka-console-producer.sh](https://kafka.apache.org/quickstart#quickstart_send) to send messages from stdin 

```
> bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test
message1
message2
```

or file.  

```
> bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test < messages.txt
```

messages send from above methods are parsed as values. If you want to send 10 messages from console producer with explicitly defined key.

```
	for (( i=1; i<=10; i++ )); do echo "key$$i:value$$i" | bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test --property "parse.key=true" --property "key.separator=:"; done;
```
