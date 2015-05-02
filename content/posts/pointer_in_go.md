+++
date = "2015-04-26T07:40:00-06:00"
draft = false
title = "Pointer type in Go"

+++

Go has pointer but no pointer arithmatic. Go is strict about memory safety but sometime you need to get access to pointers. I am working on a task where I am porting some C code to Go. C code is using a lot of pointers and I wanted a way to replicate same in Go. Go has a package called [unsafe](https://golang.org/pkg/unsafe/#Pointer) and unsafe package provides a Pointer type.

```
package main

import (
	"fmt"
	"unsafe"
)

func main() {
	type test struct{}
	var myTest = new(test)
	myPtr := unsafe.Pointer(myTest)
	fmt.Printf("%T", myPtr)
}

```

`myPtr` is "unsafe.Pointer" type and if you want to use any operator or cast it to any other pointer, cast it to `uintptr` first.

```
package main

import (
	"fmt"
	"unsafe"
)

func main() {
	type test struct{}
	var myTest = new(test)
	myPtr := unsafe.Pointer(myTest)

	newMyPtr := uint32(myPtr)
	fmt.Printf("%T", newMyPtr)
}
```

This will generate an error "cannot convert myPtr (type unsafe.Pointer) to type uint32".

```
package main

import (
	"fmt"
	"unsafe"
)

func main() {
	type test struct{}
	var myTest = new(test)
	myPtr := unsafe.Pointer(myTest)

	newMyPtr := uint32(uintptr(myPtr))
	fmt.Printf("%T", newMyPtr)
}
```
This works fine.

Just be carefull when using unsafe package. If not used properly you might end up looking at memory leaks.