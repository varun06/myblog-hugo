+++
date = "2017-02-21T16:19:52-06:00"
title = "go slice array allocation gotcha"
categories = ["general","technical"]
tags = ["general","blog"]

+++

Why is memory is allocated differently when you preallocate a slice and an array in golang.

```
slicey := make([]byte, 1024*1024)
```

`top` shows there is no extra memory allocated while a program with that slice is running.

```
arr := [1024*1024]byte{}
```

`top` shows that memory is allocated while that program is running. 

I am baffled why there is difference when slice also has a backing array that need to be initialized?

**Program you can run**
```
package main

import (
	"fmt"
	"time"
)

func main() {
	fmt.Println("start")
	time.Sleep(10 * time.Second)
	fmt.Println("go!")
	slicey := make([]byte, 1024*1024)
	time.Sleep(time.Minute)
}
```
`go run` and check `top`

Note - I ran this on `Mac OSX El Capitan`
