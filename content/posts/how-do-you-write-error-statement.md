+++
tags = [
  "general",
  "blog",
]
categories = [
  "general",
  "technical",
]
date = "2016-12-22T12:48:00-06:00"
title = "how do you write error statement"

+++

In go, when I write an error statement, I don't keep any space between function call and error check statement, such as -

```
something, err := doSoemthing()
if err != nil {
	//handle error
}
```

But I have also seen people doing following - 

```
something, err := doSoemthing()

if err != nil {
	//handle error
}
```

How do you write that error check?
