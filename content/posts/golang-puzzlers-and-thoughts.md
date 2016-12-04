+++
tags = [
  "general",
  "blog",
]
categories = [
  "general",
  "technical",
]
date = "2016-12-04T07:15:59-06:00"
title = "go puzzlers and thoughts"

+++

[Dave Cheney](https://dave.cheney.net/) gave a talk on [go](http://golang.org) [puzzlers](https://talks.godoc.org/github.com/davecheney/presentations/gopher-puzzlers.slide#1). It is a great talk and I encourage you to give it a good read. 

```
package main

import "fmt"

func main() {
    m := make(map[string]int)
    m["foo"]++
    fmt.Println(m["foo"])
}
```
**Zero Values:**

Dave asks "Is it going to compile and if yes, what will be the output"? If you look closely, it is related to [zero value](https://golang.org/ref/spec#The_zero_value) for a type. When we initialize `m := make(map[string]int)`, both string and int gets `""` and `0` values respectively. So increment works as usual.

```
package main

import "fmt"

func main() {
    m := map[string]int{}
    m["foo"]++
    fmt.Println(m["foo"])
}
```

This will also work as literal map declaration is same as using `make`.

**Multiple init():**

```
package main

func init() {}
func init() {}

func main() {}
```

Will this compile? 

Yes, because init(), init() can appear multiple times in a package. Any other multiple function declarations will fail. 

```
package main

func foo() {}
func foo() {}

func main() {}
```

Fails with `foo redeclared in this block`. [Playground](https://play.golang.org/p/czghNc45Nd)

If there are multiple init() in a package, they are called in the order they are declared. Also you can't make an explicit call to `init()` in your code, it will fail.

More info on [init()](https://golang.org/doc/effective_go.html#init)

**panic messages are written to `os.Stderr`**

language keywords such as `default` etc. should not be used as an identifier. `string` and `len` are predeclared identifiers. Predeclared identifiers are at universe block, so you can can shadow them inside smaller scopes, including the package block. But don't shadow predeclared identifiers as it will make code less readable and error prone.

There are many more puzzles in Dave's slide. Go have a read.

Note - The code examples here are used from Dave's talk. My intention is to solve and think about some puzzles here.
