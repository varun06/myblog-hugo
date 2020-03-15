+++
categories = ["general", "technical"]
date = "2016-07-04T22:05:36-05:00"
tags = ["general", "blog"]
title = "bash fifos and golang channel"

+++

I have been reading about [bash](https://en.wikipedia.org/wiki/Bash_(Unix_shell)) this weekend and came to know about [FIFOs](http://www.linuxjournal.com/content/using-named-pipes-fifos-bash). After first glance I found similarities between `named pipes` and `golang channel`. 

`FIFOs` are created using the `mkfifo` command.

```
$ mkfifo test
```

`FIFOs` provide a `named pipe` to shuttle data from one place to another. If we create a FIFO and send some data to it, it will remain blocked forever, until a command tries to read from it. If you are familiar with golang and golang channels, that's an [Unbuffered/synchronous channel](https://golang.org/doc/effective_go.html#channels). Unbuffered channel blocks until there is a receiver receiving from a channel.

`named pipes` are very interesting and can be used in some interesting ways.
