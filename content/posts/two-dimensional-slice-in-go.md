---
title: "Two Dimensional Slice in Go"
date: 2019-01-22T06:55:44-06:00
---
Create a 2-dimensional boolean slice and initialize it in go.

```
isSomething := make([][]bool, length)
for i := range isSomething {
	isSomething[i] = make([]bool, length)
}

```
