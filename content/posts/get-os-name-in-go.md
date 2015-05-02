+++
date = "2015-01-03T06:13:00"
draft = false
title = "Get operating system name in Go"

+++

# Get operating system name in Go

To get the operating system name where we running a Go program, we can use **runtime** package. **runtime.GOOS** return the operating system name. Some people try to use **os.Getenv("GOOS")** but it is not very reliable. I always use [runtime package](http://golang.org/pkg/runtime/).


```language=go
package main

import (
	"fmt"
	"runtime"
)

func main() {
	var goos string = runtime.GOOS
	fmt.Printf("The operating system is: %s\n", goos)
}

```