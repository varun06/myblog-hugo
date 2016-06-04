+++
categories = ["general", "technical"]
date = "2016-06-04T06:23:57-05:00"
draft = true
tags = ["general", "blog", "consul"]
title = "consul service discovery golang"

+++

consul is a service discovery tool from hashicorp. Consul provides a consistent view of services and configuration. Consul monitors and changes service information based on the health of nodes. Consul provides a REST interface and web UI to see services and service configs. Consul organizes services in service catalog and provides a DNS/REST/HTTP interface to it.

To use Consul you start up an agent process. The Consul agent process is a long running daemon on every member of Consul cluster. The agent process can be run in server mode or client mode. Consul agent clients would run on every physical server or OS virtual machine (if that makes more sense). Client runs on server hosting services. The clients use gossip and RPC calls to stay in sync with Consul.

Consul is built on top of serf[a full gossip protocol](https://www.serfdom.io/). 

## setting up a local consul cluster

Download consul [download](https://www.consul.io/downloads.html)
We will setup a consul node. We can have more than one but for our testing we will have one node running in server mode. To reduce the amount of command line arguments, I will use a config file to start up the servers. When you are starting up a new server cluster you typically put one of the servers in **bootstrap** mode. This tells consul that this server is allowed to elect itself as leader.

```json
{
  "datacenter": "dc1",
  "data_dir": "/etc/consul",
  "log_level": "INFO",
  "node_name": "server",
  "server": true,
  "bootstrap" : true,
  "ports" : {

    "dns" : -1,
    "http" : 9500,
    "rpc" : 9400,
    "serf_lan" : 9301,
    "serf_wan" : 9302,
    "server" : 9300
	}
  }
```
