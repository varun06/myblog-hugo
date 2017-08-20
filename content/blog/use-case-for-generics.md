---
title: "Generics - I Wish You Were Here..."
date: 2017-08-19T07:02:42-05:00
draft: true
---

There is a lot that can be/has been said about `generics` is `go`. I am going to keep this post short and simple and going to document a use case where I think `generics` in go might have been useful for my team.

I like how easy it is to build command line applications in `go`, So we have a common framework for building command line apps. But different command line applications need to have different configuration that we need to pass to common framework. This is where the need for `generics` pop up, as you can see `Configuration` type(in doe below) is an `interface{}` and we need to do runtime assertion(such as `cfg := configuration.(*appConfig)`) to get the config. If `go` had generics, we could have a generic type instead of an `interface{}`.

```
type (
	//Configuration is a marker interface to use because we don't have generics
	//It is used when passing a configuration object around
	Configuration interface{}

	//Configure is a function that updates a passed in Configuration with values from the cli.Context
	Configure func(context.Context, *cli.Context, Configuration) error

	//Application is a struct that holds the definition of the application to run
	Application struct {
		Name          string
		Description   string
		Version       string
		Options       []cli.Flag
		Subcommands   []cli.Command
		Action        Action
		Configurers   []Configure
		SetEndpoint   SetEndpoint
		Configuration Configuration
	}
)
```
