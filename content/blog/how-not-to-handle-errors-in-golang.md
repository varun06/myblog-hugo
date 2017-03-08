+++
tags = [
  "golang",
  "errors",
]
categories = [
  "technical",
  "programming"
]
date = "2016-10-27T10:40:33-05:00"
title = "how not to handle errors in golang"

+++

People have a love and hate relationship with golang error handling. Golang's use to return values for error handling seems to have as many detractors as admirers. In golang, errors are of immediate interest, so you handle them then and there, so it very common to see code like this -

```
var user User
err := json.Marshal(data, &user)
if err != nil {
	return err
}
```

In a large code base, you see `if err != nil` a lot. So people find ways to minimize that, one such approach is creating a common `util` package and then create common convenience error functions such as -

```
func FailIfNil(t *testing.T, i interface{}) {
	if IsNil(i) {
		//handle error here
	}
}
```

These common functions seems helpful, but again, in a large code base, they get out of hand quickly. Debugging becomes difficult. 

My suggestion would be handle errors when and where you see them. keep things simple and readable. Also if you want to do something with your errors, use a good library such as [this](https://github.com/davecheney/errors) one from [Dave Cheney](http://dave.cheney.net/).
