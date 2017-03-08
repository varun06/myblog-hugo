+++
date = "2017-01-27T15:02:51-06:00"
title = "http multiple registration error in go"
categories = ["go","technical"]
tags = ["go","blog", "TIL"]

+++

Today while adding a simple http endpoint to one of our app, I saw this `panic: http: multiple registrations with /myhandler`. My code was simply

```
go func(){
	http.Handler("/request", requesthandler)
	http.ListenAndServe(":9000", nil)
}
```

I read some official documentation and asked around. I came to know it happens if you use `defaultHTTPMux`, which doesn't support multiple registrations. This can be fixed with

```
go func(){
	mux := http.NewServeMux()
	mux.Handler("/request", requesthandler)
	http.ListenAndServe(":9000", nil)
}
```

