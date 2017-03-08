+++
categories = ["general", "technical"]
date = "2016-06-11T06:23:57-05:00"
tags = ["general", "blog", "consul"]
title = "consul service discovery using golang"

+++

## What is Service discovery:

Service discovery is a key component of most distributed systems and service oriented architectures. The problem seems simple at first: 

*How do clients determine the IP and port for a service that exist on multiple hosts?*

Usually, we start off with some static configuration which gets us pretty far. Things get more complicated as we start deploying more services. There are many ways service locations can change in a live system, auto or manual scaling, new deployments of services, as well as hosts failing or being replaced.

Dynamic service registration and discovery becomes very important in these scenarios in order to avoid service interruption.

There are two sides to the problem of locating services. 
	• Service Registration 
	• and Service Discovery.

#### Service Registration: 
The process of a service registering its location in a central registry. It usually register its host and port and sometimes authentication credentials, protocols, versions numbers, and/or environment details.

#### Service Discovery: 
The process of a client application querying the central registry to learn of the location of services.

Example of popular service discovery systems are Consul, Zookeeper, etcd etc. Out of these, Consul is the only one that really tries to provide a comprehensive solution for service discovery.

#### Consul:

consul is a service discovery tool from [hashicorp](https://www.hashicorp.com/). Consul provides a consistent view of services and configuration. Consul monitors and changes service information based on the health of nodes. Consul provides a REST interface and web UI to see services and service configurations. Consul organizes services in service catalog and provides a DNS/REST/HTTP interface to it.

* **Service Discovery**: Clients of Consul can provide a service, such as API or postgresql, and other clients can use Consul to discover providers of a given service. Using either DNS or HTTP, applications can easily find the services they depend upon.

* **Health Checking**: Consul clients can provide any number of health checks, either associated with a given service ("is the webserver returning 200 OK"), or with the local node ("is memory utilization below 90%"). This information can be used by an operator to monitor cluster health, and it is used by the service discovery components to route traffic away from unhealthy hosts.

* **Key/Value Store**: Applications can make use of Consul's hierarchical key/value store for any number of purposes, including dynamic configuration, feature flagging, coordination, leader election, and more. The simple HTTP API makes it easy to use.

* **Multi Datacenter**: Consul supports multiple datacenters out of the box. This means users of Consul do not have to worry about building additional layers of abstraction to grow to multiple regions.

To use Consul you start up an agent process. The Consul agent process is a long running daemon on every member of Consul cluster. The agent process can be run in server mode or client mode. Consul agent clients would run on every physical server or OS virtual machine (if that makes more sense). Client runs on server hosting services. The clients use gossip and RPC calls to stay in sync with Consul.

Consul is built on top of serf, [ a full gossip protocol](https://www.serfdom.io/). 

## setting up a local consul cluster

consul can be downloaded from [consul](https://www.consul.io/downloads.html) website . On OSX, if you are using homebrew as a package manager, consul can be installed from homebrew.

```
brew cask install consul
```

Verify the installation by running:

```
$ consul
usage: consul [--version] [--help] <command> [<args>]

Available commands are:
	agent          Runs a Consul agent
	configtest     Validate config file
	event          Fire a new event
	exec           Executes a command on Consul nodes
	force-leave    Forces a member of the cluster to enter the "left" state
	info           Provides debugging information for operators
	join           Tell Consul agent to join cluster
	keygen         Generates a new encryption key
	keyring        Manages gossip layer encryption keys
	leave          Gracefully leaves the Consul cluster and shuts down
	lock           Execute a command holding a lock
	maint          Controls node or service maintenance mode
	members        Lists the members of a Consul cluster
	monitor        Stream logs from a Consul agent
	reload         Triggers the agent to reload configuration files
	rtt            Estimates network round trip time between nodes
	version        Prints the Consul version
	watch          Watch for changes in Consul
```
If you get an error, set your PATH correctly.

After Consul is installed, the agent must be run. The agent can run either in server or client mode. Each datacenter must have at least one server, a cluster of 3 or 5 servers is recommended.

All other agents run in client mode. A client is a very lightweight process that registers services, runs health checks, and forwards queries to servers. The agent must be run on every node that is part of the cluster so that we can get information from every node.

*-dev* will run consul in  dev mode.

```
consul agent -dev
```

We can use CTRL+C to stop the consul server.

We have a server running, now let's add a service to our consul server.

#### Consul Service:

A service can be defined by providing a consul [service definition](https://www.consul.io/docs/agent/services.html) or by making [HTTP calls](https://www.consul.io/docs/agent/http/agent.html#agent_service_register) to consul server.

#### Example service definition:

```
{
  "service": {
    "name": "myservice",
    "tags": ["prod"],
    "address": "127.0.0.1",
    "port": 8000,
    "enableTagOverride": false,
    "checks": [
      {
        "script":"check",
        "interval": "10s"
      }
    ]
  }
  }
```

#### Querying Consul service

We can query consul service using DNS or HTTP API.

#### DNS API:

```
dig @127.0.0.1 -p 8600 myservice.service.consul
```

#### HTTP API:

```
curl http://localhost:8500/v1/catalog/service/myservice
```

Once we have our server and client up and running. We can use consul to find our services

#### Service Discovery from Golang:

We can use both DNS and HTTP [API](https://godoc.org/github.com/hashicorp/consul/api) to discover service information from consul. I have only used HTTP API and that's what we are going to use today. We create an interface that give us methods to register, deregister, and get services from consul.

Example:

```
Package consul

import (
	"fmt"
	"time"

	consul "github.com/hashicorp/consul/api"
)

//Client provides an interface for getting data out of Consul
type Client interface {
// Get a Service from consul
	Service(string, string) ([]string, error)
// Register a service with local agent
	Register(string, int) error
// Deregister a service with local agent
	DeRegister(string) error
}

type client struct {
	consul *consul.Client
}

//NewConsul returns a Client interface for given consul address
Func NewConsulClient(addr string) (Client, error) {
	config := consul.DefaultConfig()
	config.Address = addr
	c, err := consul.NewClient(config)
	if err != nil {
		return nil, err
	}
	return &client{consul: c}, nil
}

// Register a service with consul local agent
func (c *client) Register(name string, port int) error {
	reg := &consul.AgentServiceRegistration{
		ID:   name,
		Name: name,
		Port: port,
	}
	return c.consul.Agent().ServiceRegister(reg)
}

// DeRegister a service with consul local agent
func (c *client) DeRegister(id string) error {
	return c.consul.Agent().ServiceDeregister(id)
}

// Service return a service 
func (c *client) Service(service, tag string) ([]*ServiceEntry, *QueryMeta, error) {
	passingOnly := true 
	addrs, meta, err := c.consul.Health().Service(service, tag, passingOnly, nil)
	if len(addrs) == 0 && err == nil {
		return nil, fmt.Errorf("service ( %s ) was not found", service)
	}
	if err != nil {
		return nil, err
	}
	return addrs, meta, nil
}
```

Now when we have consul running and we know how to interact with consul with golang. It is time to build . 

Also, if you have any question, feel free to ping me [@varunksaini](https://twitter.com/varunksaini).
