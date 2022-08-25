+++
categories = ["general", "technical"]
date = "2016-05-22T06:52:53-05:00"
tags = ["general", "blog"]
title = "pretty print JSON in golang"

+++

JSON is a very common standard to transmit data objects. [go](https://golang.org) provides great support for JSON. [JSON package](https://golang.org/pkg/encoding/JSON/) in standard library provides the methods to work with JSON in a go program. Generally we use JSON to tranmit the data but sometime we need to print the JSON data too. If a human eye is going to look at that data, it is a good idea to pretty print that JSON. Here is small function that will do that:

```
func prettyPrintJSON(b []byte) ([]byte, error) {
	var out bytes.Buffer
	err := JSON.Indent(&out, b, "", "    ")
	return out.Bytes(), err
}
```

This function takes a byte array and indent the JSON. Each element in JSON object begins on a new line.
