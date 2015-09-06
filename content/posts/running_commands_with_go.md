
+++
date = "2015-07-12T19:58:28-06:00"
draft = false
title = "running commands with go"

+++

Sometimes we need to run external commands programatically to use the output of the command to drive the execution. Go provides a nice interface to run the external commands through [exec](https://golang.org/pkg/os/exec/) package. Running an external command is very easy and an example is given below.

```
package main

import (
	"fmt"
	"log"
	"os/exec"
)

func main() {
	out, err := exec.Command("date").Output()
	if err != nil {
		log.Fatal(err)
	}
	fmt.Printf("The time is %s\n", out)
}
```

`exec` package provides some other useful methods to work with external commands. Use this powerful package to build awesome things.
