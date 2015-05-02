+++
date = "2014-12-13T06:40:15-06:00"
draft = false
title = "Working with files in go lang"

+++

# Working with files in go lang

Go makes working with file very easy and file reading is an operation that is used very frequently.

To open a file in Go, we can use "Open" function from the "os" package.

```language=Go
package main

import (
	"fmt"
	"os"
)

func main() {
	file, err := os.Open("test.txt")
	if err != nil {
		fmt.Println("erros is: ", err)
		return
	}
	defer file.Close()

	size, err := file.Stat()
	if err != nil {
		fmt.Println("erros is: ", err)
		return
	}

	fs := make([]byte, size.Size())
	_, err = file.Read(fs)
	if err != nil {
		fmt.Println("erros is: ", err)
		return
	}

	str := string(fs)
	fmt.Println(str)
}
```

I really like how you can simply defer the file close operation just after creating a file object. In Go you use "defer" to do that. any function that use defer will excute in the end. This way we don't have to worry about forgeting closing the file.

There is a shorter way to read files too.

```language=Go
package main

import (
	"fmt"
	"io/ioutil"
)

func main() {
	fs, err := ioutil.ReadFile("test.txt")
	if err != nil {
		fmt.Println("Error is: ", err)
	}

	str := string(fs)
	fmt.Println(str)
}
```

If we want to create a file instead of reading it, just use

```language=Go
file, err := os.Create("test.txt")
```