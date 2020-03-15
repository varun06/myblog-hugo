---
title: "Reverese Integer in Go"
date: 2019-01-20T16:15:45-06:00
---

a simple function to reverse integer in go.

```go
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

```go
//negative numbers and 32 bit integer overflow is handled
func reverse(x int) int {
    isNegative := false
    maxInt32 := 1<<31 - 1
    if x < 0 {
        isNegative = true
        x = -x
    }
    
    res := 0
    for x > 0 {
        res = res*10 + x%10
        x /= 10
    }
    
    if res > maxInt32 {
        return 0
    }
    
    if isNegative {
        return -res
    }
    return res 
}

```
