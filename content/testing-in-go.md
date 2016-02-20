+++
date = "2015-05-09T06:41:00-06:00"
draft = false
title = "testing in go lang"
+++

Testing is an integral part of software development and as a squad (if you are wondering what is a squad in software company setting, check [Spotify Culture](https://vimeo.com/85490944)) in [MediaMath](https://www.mediamath.com), our mantra is that **"Regrassion Resistence is a software requirement"** and should be taken care from the start of the project. We give a lot of emphasis on testing the software and having a good test coverage. We have written some tools around `go coverage` and `go get` [cove](https://github.com/MediaMath/cove) to help us with our testing process.

Go is a batteries included programming language. Go provides testing as part of standard library and that means testing is a first class citizen in Go world. Writing a test in Go is as easy as writing a function. The test function start with **TestXXXXX** and you can write as many tests as you want. If you have a file such as **"github_api.go"**, you can group the tests(create a test suite) for that file in a test file with a name as **"github_api_test.go"**.

Go tests are run with **`go test`** command.

##### A Sample function:

```
package abc

func Add(a, b int) int {
	return a + b
}
```
##### Test function:

```
package abc

import "testing"

func TestAdd(t *testing.T) {
	var a, b int = 2, 3
	v := Add(a, b)
	if v != 5 {
		t.Error("Expected 5, got ", v)
	}
}
```

You can learn more about Go lang testing package at [testing](http://golang.org/pkg/testing/), if you want to look at the source code [testing source code](http://golang.org/src/testing/testing.go).

P.S. In Go documentation, if you want to check package documentation just use "http://golang.org/pkg/(packagename)" and if you want source code "http://golang.org/src/(packagename)".