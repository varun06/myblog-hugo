---
title: "Auto Instrumenting a Go server using Open Telemetry"
description: "OpenTelemetry and instrumentation"
date: 2021-05-16T16:20:44-05:00
tags: [Go, Open Telemetry, Instrumentation, Observability]
---

[OpenTelemetry](https://opentelemetry.io) is an observability framework – an API, SDK, and tools that are designed to aid in the generation and collection of application telemetry data such as metrics, logs, and traces.

There are 2 ways to instrument a Go application. 

1. Manual Instrumentation
2. Auto Instrumentation

Instrumenting an application generally involves a significant manual effort on developer part. [Open Telemetry](opentelemetry.io) for Go(and many other popular languages) supports auto instrumentation using wrappers and helper functions around many popular frameworks and libraries in Go programming languages.

Here is the [list](https://github.com/open-telemetry/opentelemetry-go-contrib/tree/main/instrumentation) and [registry](https://opentelemetry.io/registry/) of these instrumentations in OpenTelemetry.

## Sample Go application with auto-instrumentation for tracing

Today we are going to write some simple code to instrument a [net/http](https://golang.org/pkg/net/http/) server with openTelemetry tracing.

### tracing.go file

```go
package main

import (
	"log"

	"go.opentelemetry.io/otel"
	"go.opentelemetry.io/otel/exporters/stdout"
	"go.opentelemetry.io/otel/propagation"
	"go.opentelemetry.io/otel/sdk/resource"
	sdktrace "go.opentelemetry.io/otel/sdk/trace"
	"go.opentelemetry.io/otel/semconv"
)

func initTracer() {
	// Create stdout exporter to be able to retrieve
	// the collected spans.
	exporter, err := stdout.NewExporter(stdout.WithPrettyPrint())
	if err != nil {
		log.Fatal(err)
	}

	// use sdktrace.AlwaysSample sampler to sample all traces.
	tp := sdktrace.NewTracerProvider(
		sdktrace.WithSampler(sdktrace.AlwaysSample()),
		sdktrace.WithSyncer(exporter),
		sdktrace.WithResource(resource.NewWithAttributes(semconv.ServiceNameKey.String("ExampleService"))),
	)
	if err != nil {
		log.Fatal(err)
	}
	otel.SetTracerProvider(tp)
	otel.SetTextMapPropagator(propagation.NewCompositeTextMapPropagator(propagation.TraceContext{}, propagation.Baggage{}))
}
```

### server.go file

```go
package main

import (
	"io"
	"net/http"

	"go.opentelemetry.io/contrib/instrumentation/net/http/otelhttp"

	"go.opentelemetry.io/otel/attribute"
	"go.opentelemetry.io/otel/baggage"
	"go.opentelemetry.io/otel/trace"
)

func main() {

	// initialize otel tracing for server
	initTracer()

	helloHandler := func(w http.ResponseWriter, req *http.Request) {
		ctx := req.Context()
		// Add a trace span using request context
		span := trace.SpanFromContext(ctx)
        span.SetName("handling request")

		_, _ = io.WriteString(w, "Hello, world!\n")
	}

	// Wrapping http handlerwith otel auto instrumentation
	autoInstrumentedHandler := otelhttp.NewHandler(http.HandlerFunc(helloHandler), "Hello")

	http.Handle("/hello", autoInstrumentedHandler)
	err := http.ListenAndServe(":7777", nil)
	if err != nil {
		panic(err)
	}
}
```

When I make a call to my otel instrumented net/http server, this is the response that I get.

```sh
    HTTP/1.1 200 OK
    Traceparent: 00-44f20dd6c5ee98caf23a7dc36fa0d678-a58ae87ff5f41c40-01
    Tracestate: 
    Date: Sun, 16 May 2021 21:40:57 GMT
    Content-Length: 14
    Content-Type: text/plain; charset=utf-8

    Hello, world!
```

And this is the trace information from stdout tracer.

```json
[
        {
                "SpanContext": {
                        "TraceID": "b540d70b95e78680a2e3ef0393738072",
                        "SpanID": "302651dc6df28fd3",
                        "TraceFlags": "01",
                        "TraceState": null,
                        "Remote": false
                },
                "Parent": {
                        "TraceID": "00000000000000000000000000000000",
                        "SpanID": "0000000000000000",
                        "TraceFlags": "00",
                        "TraceState": null,
                        "Remote": false
                },
                "SpanKind": 2,
                "Name": "handling request",
                "StartTime": "2021-05-16T16:54:29.824377-05:00",
                "EndTime": "2021-05-16T16:54:29.824447353-05:00",
                "Attributes": [
                        {
                                "Key": "net.transport",
                                "Value": {
                                        "Type": "STRING",
                                        "Value": "IP.TCP"
                                }
                        },
                        {
                                "Key": "net.peer.name",
                                "Value": {
                                        "Type": "STRING",
                                        "Value": "[::1]"
                                }
                        },
                        {
                                "Key": "net.peer.port",
                                "Value": {
                                        "Type": "INT64",
                                        "Value": 53068
                                }
                        },
                        {
                                "Key": "net.host.name",
                                "Value": {
                                        "Type": "STRING",
                                        "Value": "localhost"
                                }
                        },
                        {
                                "Key": "net.host.port",
                                "Value": {
                                        "Type": "INT64",
                                        "Value": 7777
                                }
                        },
                        {
                                "Key": "http.method",
                                "Value": {
                                        "Type": "STRING",
                                        "Value": "GET"
                                }
                        },
                        {
                                "Key": "http.target",
                                "Value": {
                                        "Type": "STRING",
                                        "Value": "/hello"
                                }
                        },
                        {
                                "Key": "http.server_name",
                                "Value": {
                                        "Type": "STRING",
                                        "Value": "Hello"
                                }
                        },
                        {
                                "Key": "http.user_agent",
                                "Value": {
                                        "Type": "STRING",
                                        "Value": "curl/7.64.1"
                                }
                        },
                        {
                                "Key": "http.scheme",
                                "Value": {
                                        "Type": "STRING",
                                        "Value": "http"
                                }
                        },
                        {
                                "Key": "http.host",
                                "Value": {
                                        "Type": "STRING",
                                        "Value": "localhost:7777"
                                }
                        },
                        {
                                "Key": "http.flavor",
                                "Value": {
                                        "Type": "STRING",
                                        "Value": "1.1"
                                }
                        },
                        {
                                "Key": "http.wrote_bytes",
                                "Value": {
                                        "Type": "INT64",
                                        "Value": 14
                                }
                        },
                        {
                                "Key": "http.status_code",
                                "Value": {
                                        "Type": "INT64",
                                        "Value": 200
                                }
                        }
                ],
                "MessageEvents": null,
                "Links": null,
                "StatusCode": "Unset",
                "StatusMessage": "",
                "DroppedAttributeCount": 0,
                "DroppedMessageEventCount": 0,
                "DroppedLinkCount": 0,
                "ChildSpanCount": 0,
                "Resource": [
                        {
                                "Key": "service.name",
                                "Value": {
                                        "Type": "STRING",
                                        "Value": "ExampleService"
                                }
                        }
                ],
                "InstrumentationLibrary": {
                        "Name": "go.opentelemetry.io/contrib/instrumentation/net/http/otelhttp",
                        "Version": "semver:0.20.0"
                }
        }
]
```

As you can see, it is quite easy to instrument a server using open telemetry in Go, Trace output becomes even more interesting when used with a trace UI such as [Jeager](https://www.jaegertracing.io), [Tempo](https://grafana.com/oss/tempo/) etc.
