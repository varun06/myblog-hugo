
+++
tags = [
  "golang",
  "blog",
]
categories = [
  "programming",
  "technical",
]
date = "2017-06-29T21:10:59-05:00"
title = "running a single test multiple times in golang"

+++

[go](https://golang.org) provides a great standard library for [testing](https://golang.org/pkg/testing/). To test a function/method, just create `name_test.go` in same package and write you tests. 

Go also provides `go test` tool to run the tests in a package. running `go test` in a package runs all the tests in that package and `go test -run <testname>` runs only given test. 

But what if you want to run test multiple times, `go test` to rescue, 

`go test -run <testname> -count 100` 

will run given test 100 times.