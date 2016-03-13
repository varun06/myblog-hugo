+++
categories = ["general", "technical"]
date = "2016-03-13T07:57:24-05:00"
tags = ["general", "blog"]
title = "unmarshal to map"

+++


When you unmarhsal json to a map, always pass the reference to map object. This is very subtle and I fixed two bugs last week related to same thing.

```
var m map[string]string
err := json.Unmarshal(data, m)
if err != nil {
	return err
}
```

The code snippet above will not fail/err. But when you look at m, you will get nothing. To fix this, we need to pass the reference to m in `json.Unmarshal`.

```
var m map[string]string
err := json.Unmarshal(data, &m)
if err != nil {
	return err
}
```
