---
title: "Can we use slice as Map Keys in Go"
description: ""
date: 2021-04-01T06:39:37-05:00
draft: false
tags: [go, slice, map]
---

Question: Can we use slice as map key in Go?
Short answer is **No**

Do you want to know more?
Okay, Let's have a look at spec.

From [Map spec](https://golang.org/ref/spec#Map_types):

> The comparison operators == and != must be fully defined for operands of the key type; thus the key type must not be a function, map, or slice.

Map spec already tells us that slice can't be a key, but we can also check it in the [comparison spec](https://golang.org/ref/spec#Comparison_operators):

> Slice, map, and function values are not comparable.

This means slice can't be a key in a map, but an array can be a key. For example we can write:

```go
    testMap := map[[2]string]string{
        [2]string{"a", "b"} : "ab",
    }
```

There is our answer, slices can't be key in Map, but an array can be.