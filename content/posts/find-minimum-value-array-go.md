+++
date = "2014-11-26T06:24:00-06:00"
draft = false
title = "Find Mimimum Value in an array in go"

+++

# How to find a min array value in go lang:

```go
package main

import (
	"fmt"
)

func main() {
	x := []int{
		48, 96, 86, 68,
		57, 82, 63, 70,
		37, 34, 83, 27,
		19, 97,  9, 17,
	}

	min:= x[0]

	for _, value := range x {
		if value < min {
			min = value
		}
	}
	fmt.Println(min)
}
```