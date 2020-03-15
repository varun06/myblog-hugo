+++
categories = ["general", "technical"]
date = "2016-06-17T16:56:36-05:00"
tags = ["general", "blog"]
title = "using consul acl with golang"

+++

It is always a good idea to think about security. It is no exception when we are using [Consul](https://www.consul.io) for service discovery. Consul provides an optional Access Control List [ACL](https://en.wikipedia.org/wiki/Access_control_list) system which can be used to control access to data and APIs. An access control list (ACL) is a list of permissions attached to an object.

Consul ACL is [Capability-based](https://en.wikipedia.org/wiki/Capability-based_security). If you are familiar with AWS IAM, it will look similar to AWS IAM.

To enable consul with ACL, add this to server configuration.

```
{
  "acl_datacenter": "<datacenter name>",
  "acl_master_token": "<token>",
  "acl_default_policy": "deny",
  "acl_down_policy": "deny"
}
```

Consul with this configuration will 'deny' by default and we can allow read/write accesses per client.

We can list the ACL's with this curl command: 

```
curl "http://localhost:8500/v1/acl/list?token=token&pretty=true"
```
**Note**: Consul is running on port 8500 at localhost.

If we want to get a value from key/value store. We can use a curl like:

```
curl "http://localhost:8500/v1/kv/timeout?token=token"
```
**Note**: `timeout` is a key in Consul [key/value](https://www.consul.io/docs/agent/http/kv.html) store.

If you are using [golang](https://golang.org/), Consul provides an [api](https://github.com/hashicorp/consul/tree/master/api). 
With official Consul api, accessing a service or key/value store while ACL enabled is just adding token to [QueryOption](https://godoc.org/github.com/hashicorp/consul/api#QueryOptions) 

```
options := &consulapi.QueryOption{
	Token: token,
}

pairs, meta, err := consulapi.Get("timeout", coptions)
if err != nil {
	return nil, nil, err
}
```

More information about Consul [ACL](https://www.consul.io/docs/internals/acl.html).
