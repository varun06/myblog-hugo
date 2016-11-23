+++
title = "question about type assertion in go"
tags = [
  "golang",
  "blog",
  "question",
]
categories = [
  "technical",
]
date = "2016-11-23T09:47:56-06:00"

+++

One of our go app crashed recently because of a bug in https://github.com/urfave/cli/, here is the [PR](https://github.com/urfave/cli/pull/568) with fix from my collegue who found the issue. Then we started talking about it internally and found something that's interesting. I understand some of it but not fully so I thought of asking people who might know.  

My question is why `bar` works but not `foo`.

```
package main

import (
	"fmt"
)

func main() {
	var f interface{}
	var b interface{}
	f = foo()
	b = bar()

	if _, ok := f.(func(string) error); ok {
		fmt.Println("FOUND IT")
	} else {
		fmt.Println("DIDNT FIND IT")
	}

	if _, ok := b.(func(string) error); ok {
		fmt.Println("FOUND IT")
	} else {
		fmt.Println("DIDNT FIND IT")
	}
}

type FooFunc func(string) error

func foo() func(string) error {
	return func(e string) error {
		return fmt.Errorf("GOTCHA")
	}
}

func bar() FooFunc {
	return func(e string) error {
		return fmt.Errorf("GOTCHA")
	}
}

```

[go playground](https://play.golang.org/p/4EfYIMZV-p)
