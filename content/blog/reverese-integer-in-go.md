---
title: "Reverese Integer in Go"
date: 2019-01-20T16:15:45-06:00
---

a simple function to reverse integer in go.

```
//negative numbers are not handled
func reverse(num int) int {
	z := 0
	for num > 0 {
		z = z*10 + num%10
		num /= 10
	}
	return z
}
```
