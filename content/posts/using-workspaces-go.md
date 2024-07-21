---
title: "Using Workspaces in Go and recent gotcha"
description: "Using workspaces for local development in Go"
date: 2023-03-12T06:40:31-05:00
tags: [Go, Programming, Development]
---

Go 1.18 adds workspace mode to Go, which lets you work on multiple modules simultaneously.

**Workspaces**

Go workspaces helps to work with several modules in a Go project. When you create a go.work file, Go runs through the list of modules listed in the workspace, and creates a single list of dependencies. If go.mod files have replace directives, Go will also take them into account. 

The go.work file has `use` and `replace` directives that override the individual go.mod files, so there is no need to edit each go.mod file individually.

You create a workspace by running go work init with a list of module directories as space-separated arguments. 

```Go
go work init abc,xyz
```

running go work init without arguments creates an empty workspace.

```go
go work init
```

To add modules to the workspace, run go work use [moddir] or manually edit the go.work file. 

```go
go work use foo
```

Run go work use -r to recursively add directories in the argument directory with a go.mod file to your workspace. 

A sample `go.work` file looks like this.

```go
go 1.20

use (
	.
    ./foo
    ./bar
)
```

**Gotcha**

Recently, While working with `workspaces` I got following error:

`pattern ./...: directory prefix . does not contain modules listed in go.work or their selected dependencies`

After some debugging and aksing around, I figured that I was missing `.[main module]` in `go.work` file. my go work file was looking like this:

```go
go 1.20

use (
	./foo
	../../bar
)
```

A working `go.work` file is this:


```go
go 1.20

use (
	.
	./foo
	../../bar
)
```
