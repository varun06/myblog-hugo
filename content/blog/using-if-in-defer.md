+++
tags = [
  "golang",
  "blog",
]
categories = [
  "programming",
  "technical",
]
date = "2016-11-01T21:10:59-05:00"
title = "Using if condition in a defer statement"

+++

`defer` statement is used to do basic cleanup in go, deferred calls are executed when surrounding function returns. 

```
f, err := os.Open(fileName)
    if err != nil {
        return
    }
defer src.Close()
```

We open a file and then use `defer` to close the file handle. Using `defer` makes sure that file handle is closed and we don't have any bug in our code.But what if we want to make a decision(conditional) in `defer`, is that possible? 

`defer` and `named returns` to rescue. Here we are using a form of defer that lets us do something if there is an error and something else if there is not an error.

```
package main

import (
	"errors"
	"fmt"
)

var toggleMe = true

func foo() (boo string, err error) {
	boo = "boo"

	defer func() {
		if err != nil {
			fmt.Printf(boo)
		} else {
			fmt.Println("bar")
		}
	}()

	if toggleMe {
		err = errors.New("an error occurred")
	}

	return
}

func main() {
	foo()
}
```

[Playground](https://play.golang.org/p/ap_zkRpcqQ)

I don't know if it is idiomatic go or not and that's where I need your help, let me know if this is correct to do.
