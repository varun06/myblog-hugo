---
title: "A simple tiered Cache in Go"
description: ""
date: 2021-05-09T06:18:37-05:00
draft: false
tags: [go, caching, design]
---

## What is Cache?

A cache is used to store data or files for faster access. A cache can be a hardware or software component. Data stored in a cache might be the result of an earlier computation or a copy of data stored elsewhere.

A cache hit occurs when the requested data can be found in a cache, while a cache miss occurs when data can not be found in cache. Cache hits are served by reading data from the cache, which is faster than recomputing a result or reading from a slower data store; thus, the more requests that can be served from the cache, the faster the system performs.


## What is Tiered Cache?

In case of a standard cache(CDN/Reverse Proxy), a cache miss in any data center causes a request to origin server. If you have multiple data centers, there will be multiple requests to origin server/s. Requests are made even if data is cached in another data center/s. Because we do not have access to cached data in another data centers, our cache hits numbers are not very high.

One solution is to send the requests to all the data centers, but that's not practical and quite costly.

Tiered Cache solves this problem by providing a common cache for data center/s. It improves hit ratios by providing a common cache to check before making a request to origin servers. For a request, inner/layer1 cache is checked first, if data is in inner/layer1 cache, we return right there, if data is not in inner/layer1 cache, it's checked in outer/layer2 cache. Putting works same way, data is put in both inner and outer cache.

This design is very much inspired by [L1/L2](https://en.wikipedia.org/wiki/CPU_cache) cache architecture in CPUs.

## A simple tiered cache implementation in Go

### Cacher Interface

```go
    type Cacher interface {
        Get(key string) []byte
        Put(key string, value []byte])
    }

```

### Tiered Cache

```go
    type TieredCache struct {
        inner Cacher
        outer acher
    }

    func NewTieredCache(inner, outer Cacher) Cacher {
        return &tieredCache{
            inner: inner,
            outer: outer,
        }
    }

    func (t *TieredCache) Get(key string) []byte {
        var value []byte
        value = t.inner.Get(key)
        if value == nil {
            value = t.outer.Get(key)
            // if required, add value to inner cache for future requests
        }
        return value
    }

    func (t *TieredCache) Put(key string, value []byte) {
        t.inner.Put(key, value)

        // add key to outer cache asynchronously
        go func(key string) {
            t.outer.Put(key, value)
        }(key)
    }

```

### inner cache

Inner cache can be any in-memory cache. We personally use [Ristretto](https://github.com/dgraph-io/ristretto), but there are other caches too, such as
[BigCache](https://github.com/allegro/bigcache) etc. As long as, inner cache satisfy Cacher interface, we should be able to use it as our inner cache.

### outer Cache

We Use a distributed [Memcached](https://github.com/memcached/memcached) with [go client](https://github.com/bradfitz/gomemcache) as our outer cache, but [Redis](https://redis.io) and some other caches should work fine as long as implementation satisfy Cacher interface.

## Conclusion

It was really fun to implement tiered cache at scale. Tiered cache is in use at work and providing really good cache offload and lower latency for tenants.
If you have any question about implementation or improvements, please get in touch.

### References

* More about [Cache](https://en.wikipedia.org/wiki/Cache_(computing)) at Wikipedia.
* Cloudflare uses [Tiered cache](https://blog.cloudflare.com/tiered-cache-smart-topology/) too
* [What is caching](https://www.cloudflare.com/learning/cdn/what-is-caching/) from cloudflare
