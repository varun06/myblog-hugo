---
title: "Reverese String in Go"
date: 2019-01-20T16:15:33-06:00
---

A simple function to reverse string in go. In go, a string is a read only slice of bytes. We use that fact and convert given string to a slice of byte. Once we have a slice of bytes, reversing it is just a matter of swapping individual bytes. In the end we convert the byte slice to string and return it.

```
func reverse(s string) string {
	b := []byte(s)
	i, j := 0, len(s)-1

	for i < j {
		b[i], b[j] = b[j], b[i]
		i++
		j--
	}
	return string(b)
}
```
