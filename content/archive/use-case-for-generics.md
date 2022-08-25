---
title: "Generics - I Wish You Were Here..."
date: 2017-08-19T07:02:42-05:00
---

This is an [experience report](https://github.com/golang/go/wiki/experiencereports) about how [generics](https://en.wikipedia.org/wiki/Generic_programming) in [go](https://golang.org/) could have helped us in one of our use case. There is a lot that can be/has been said about `generics` is `go`. I am going to keep this post short and simple and going to document a use case where I think `generics` in go might have been useful for us.

I like how easy it is to build command line applications in `go`, We have a common framework for building command line apps. Different command line applications need to have different configuration, that are passed to common framework. This is where the need for `generics` pop up, as you can see `Configuration` type(in code below) is an `interface{}` and we need to do [Type Assertion](https://golang.org/ref/spec#Type_assertions) such as `cfg := configuration.(*appConfig)`, to get the application configuration. 

```
type (
	//Configuration is a marker interface to use because we don't have generics
	//It is used when passing a configuration object around
	Configuration interface{}

	//Application is a struct that holds the definition of the application to run
	Application struct {
		Name          string
		Description   string
		Version       string
		Options       []cli.Flag
		Subcommands   []cli.Command
		Configuration Configuration
	}
)
```

If `go` had generics, we could have a generic type instead of an `interface{}` for the Configuration type.
