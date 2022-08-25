---
title: "Using Wasm in Envoy Proxy - Part 1"
description: ""
date: 2021-06-03T13:21:32-05:00
tags: [go, wasm, proxy, envoy, networking]
---

This is my first blog about using Wasm(Web Assembly) with http proxies at edge. In this first post, we are using tinyGo to compile go code to Wasm. In future posts, I am going to use C++ and Rust, and then talk about pros and cons of these approaches.

### What is WASM

According to [webassembly](https://webassembly.org) website,

> WebAssembly (abbreviated Wasm) is a binary instruction format for a stack-based virtual machine. Wasm is designed as a portable compilation target for programming languages, enabling deployment on the web for client and server applications.

Wasm is **Efficient and Fast**, **Safe**, **Open And debuggable**, and **part of open web Platform**. 

### What is TinyGo

According to [tinygo](https://tinygo.org) website, 

> TinyGo brings the Go programming language to embedded systems and to the modern web by creating a new compiler based on LLVM.

TinyGo can also produce WebAssembly (WASM) code which is very compact in size. You can compile programs for web browsers, as well as for server and edge computing environments that support the WebAssembly System Interface (WASI) family of interfaces.” 

### What is Envoy

According to [envoy](https://www.envoyproxy.io) website,

> envoy is an open source edge and service proxy, designed for cloud-native applications

There are multiple ways to run envoy as documented [here](https://www.envoyproxy.io/docs/envoy/latest/start/install) 

### Install TinyGo

To be able to install TinyGo you need to have Go installed first. I have personally tested this on my Mac, so I will provide instructions for MacOS, but you can find instructions for the other operating systems directly on the project website: https://tinygo.org/getting-started

You can install TinyGo on MacOS using brew:

```sh
~ brew tap tinygo-org/tools
~ brew install tinygo
```
If installation is successful, you should be able to run this:

```sh
~ tinygo version
tinygo version 0.18.0 darwin/amd64 (using go version go1.16.4 and LLVM version 11.0.0)
```

### Using Wasm in Go

```go
package main

import (
"fmt"

"github.com/tetratelabs/proxy-wasm-go-sdk/proxywasm"
"github.com/tetratelabs/proxy-wasm-go-sdk/proxywasm/types"
)

type helloHttpContext struct {
	proxywasm.DefaultHttpContext
}

func main() {
	proxywasm.SetNewHttpContext(newHttpContext)
}

func newHttpContext(uint32, uint32) 	proxywasm.HttpContext {
	return &helloHttpContext{}
}

func (ctx *helloHttpContext) OnHttpRequestHeaders(numHeaders int, _ bool) types.Action {

    if numHeaders > 0 {
        headers, err := proxywasm.GetHttpRequestHeaders()
        if err != nil {
            proxywasm.LogErrorf("failed to get request headers with '%v'", err)
            return types.ActionContinue
        }
        proxywasm.LogInfof("request headers: '%+v'", headers)
    }

    return types.ActionContinue
}

func (ctx *helloHttpContext) OnHttpRequestBody(bodySize int, endOfStream bool) types.Action {

    proxywasm.LogInfo("OnHttpRequestBody")
    proxywasm.LogInfo(fmt.Sprintf("Body size: %v\n", bodySize))
    proxywasm.LogInfo(fmt.Sprintf("End of Stream: %v\n", endOfStream))

    return types.ActionContinue

}

func (ctx *helloHttpContext) OnHttpResponseBody(bodySize int, endOfStream bool) types.Action {
    proxywasm.LogInfo("OnHttpResponseBody")
    proxywasm.LogInfo(fmt.Sprintf("Body size: %v\n", bodySize))
    proxywasm.LogInfo(fmt.Sprintf("End of Stream: %v\n", endOfStream))

    if bodySize > 0 {

        bodyContent, err := proxywasm.GetHttpResponseBody(0, bodySize)
        if err != nil {
            proxywasm.LogError(fmt.Sprintf("Error in READING RESPONSE BODY: %v\n", err))
            return types.ActionContinue
        }
        proxywasm.LogInfo(fmt.Sprintf("BODY CONTENT: %v\n", string(bodyContent)))
    }

    return types.ActionContinue
}
```

I am using a Go SDK for [Proxy-Wasm](https://github.com/proxy-wasm/spec),  Proxy-Wasm provides an interface to write wasm extensions in Go. This SDK supports tinyGo, normal [go](https://golang.org) is not supported.

### Compiling to Wasm

We will use TinyGo compiler with wasm target(wasi). 

```sh
tinygo build -o ./hello.wasm -scheduler=none -target=wasi ./main.go
```

This will give us a `hello.wasm` file, that we can use as a plugin/filter in envoy.

### Running Wasm plugin in envoy

We need to tell envoy from where to load this wasm filter/plugin. We do that by providing following information in envoy config file.

```yaml
http_filters:
- name: envoy.filters.http.wasm
typed_config:
"@type": type.googleapis.com/udpa.type.v1.TypedStruct
type_url: type.googleapis.com/envoy.extensions.filters.http.wasm.v3.Wasm
value:
config:
name: "my_plugin"
root_id: "my_root_id"
vm_config:
vm_id: "my_vm_id"
runtime: "envoy.wasm.runtime.v8"
code:
local:
filename: "hello.wasm"
allow_precompiled: true
```

Once everything is in place and we run envoy,  and make request, I see following log entries.

```sh
[info][wasm] [source/extensions/common/wasm/context.cc:1218] wasm log my_plugin my_root_id my_vm_id: OnHttpResponseBody
[info][wasm] [source/extensions/common/wasm/context.cc:1218] wasm log my_plugin my_root_id my_vm_id: Body size: 19
[info][wasm] [source/extensions/common/wasm/context.cc:1218] wasm log my_plugin my_root_id my_vm_id: BODY CONTENT: 404 page not found
```

We can see that envoy is able to apply our wasm filter on  http requests and we have logs to prove that.
