+++
title= "run tests one package at a time in go"
date= 2017-08-19T07:02:42-05:00
+++

`go test` runs concurrently on package level. If I have 2 packages, package A and package B with tests in them, when you run `go test`, tests in package A and package B will run concurrently at the same time. It is done to run tests faster and make the feedback process fast. But sometime there is need to run tests in sequential order (to keep shared state etc.). 

`go build` provides a flag to do that, that flag is `-p`. 

```
-p n
		the number of programs, such as build commands or
		test binaries, that can be run in parallel.
		The default is the number of CPUs available.
```

When using `-p` flag with `go test`, such as `go test -p 1 ./...` will run tests for one package at a time, the total running time for tests is going to be close to the sum of all individual package tests plus build times.
