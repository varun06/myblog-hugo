---
title: "Using Lua filter in Envoy Proxy"
description: ""
date: 2021-06-13T06:45:41-05:00
tags: [proxy, envoy, networking, lua]
---

In Envoy, HTTP lua filter is used to run [Lua](https://lua.org) scripts during both request and response flow. Envoy uses [LuaJIT](https://luajit.org) as Lua runtime. 

### High level design of Lua Filter

- All Lua environments are per worker thread. There is no truly global data.
- All scripts are run as coroutines. 
- Do not perform blocking operations from scripts. 
- It is critical for performance that Envoy APIs are used for all IO.

### Features supported by Lua Filter

- Inspection of headers, body, and trailers while streaming in either the request flow, response flow, or both.
- Modification of headers and trailers.
- Blocking and buffering the full request/response body for inspection.
- Performing an outbound async HTTP call to an upstream host. 
- Performing a direct response and skipping further filter iteration.

### Writing a Lua filter for Envoy

[Envoy lua](https://www.envoyproxy.io/docs/envoy/latest/configuration/http/http_filters/lua_filter#config-http-filters-lua) page provides a lot of examples on how to write lua filters for Envoy. 

We can define a Lua filter as [inline_code](https://www.envoyproxy.io/docs/envoy/latest/api-v3/extensions/filters/http/lua/v3/lua.proto#envoy-v3-api-field-extensions-filters-http-lua-v3-lua-inline-code) and it will be treated as Global script. Envoy will execute this Global script for every http request.

### Per-Route Configuration

LuaPerRoute configuration provides a way to disable or override the Lua HTTP filter. it can be used for a virtual host, route, or weighted cluster.

#### envoy config file

Save following to `envoy.yaml` in a directory.

```yaml
static_resources:
  listeners:
  - name: main
    address:
      socket_address:
        address: 0.0.0.0
        port_value: 8000
    filter_chains:
    - filters:
      - name: envoy.filters.network.http_connection_manager
        typed_config:
          "@type": type.googleapis.com/envoy.extensions.filters.network.http_connection_manager.v3.HttpConnectionManager
          stat_prefix: ingress_http
          codec_type: AUTO
          route_config:
            name: local_route
            virtual_hosts:
            - name: local_service
              domains:
              - "*"
              routes:
              - match:
                  prefix: "/"
                route:
                  cluster: web_service
          http_filters:
          - name: envoy.filters.http.lua
            typed_config:
              "@type": type.googleapis.com/envoy.extensions.filters.http.lua.v3.Lua
              inline_code: |
                function envoy_on_request(request_handle)
                  request_handle:logInfo("Hello World.)
                end
          - name: envoy.filters.http.router
            typed_config: {}

  clusters:
  - name: web_service
    type: STRICT_DNS  # static
    lb_policy: ROUND_ROBIN
    load_assignment:
      cluster_name: web_service
      endpoints:
      - lb_endpoints:
        - endpoint:
            address:
              socket_address:
                address: web_service
                port_value: 80
```

#### Docker Compose file

Save this to `docker-compose.yaml` file in same directory.

```yaml
version: "3.7"
services:

  proxy:
    build:
      context: .
      dockerfile: Dockerfile-proxy
    volumes:
      - ./envoy.yaml:/etc/envoy.yaml
    networks:
      - envoymesh
    expose:
      - "8000"
    ports:
      - "8000:8000"

  web_service:
    build:
      context: .
      dockerfile: Dockerfile-web-service
    networks:
      envoymesh:
        aliases:
          - web_service
    expose:
      - "80"
    ports:
      - "8080:80"

networks:
  envoymesh: {}

```

#### Dockerfile for Envoy

Save this to `dockerfile-proxy` in same directory.

```yaml
    FROM envoyproxy/envoy-dev:latest
    COPY ./envoy.yaml /etc/envoy.yaml
    RUN chmod go+r /etc/envoy.yaml 
    CMD ["/usr/local/bin/envoy", "-c", "/etc/envoy.yaml", "-l", "debug", "--service-cluster", "proxy"]
```

#### Dockerfile for a sample webserver

Save this to `dockerfile-web-service` in same directory.

```sh
FROM solsson/http-echo
```

Once everythign is in place, run following commands to bring everything up.

```sh
docker-compose pull
docker-compose up --build
```

These docker commands will pull envoy and web service images and run them on given ports in docker compose file. 

To check that envoy is proxying our requests to web service, run 

```sh
curl -v localhost:8000
```

You should also see following in envoy logs

```
proxy_1        | [2021-06-13 12:17:07.273][19][info][lua] [source/extensions/filters/http/lua/lua_filter.cc:795] script log: Hello World.
proxy_1        | [2021-06-13 12:17:07.273][19][debug][lua] [source/extensions/filters/common/lua/lua.cc:39] coroutine finished
```

And that's it. We have a working lua filter in envoy proxy.
 
[github](https://github.com/varun06/envoy-lua-filter/tree/master) link to code.
