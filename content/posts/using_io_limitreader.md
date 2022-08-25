+++
date = "2015-04-18T10:42:00-06:00"
draft = false
title = "using io.LimitReader to read a binary file"

+++

I was working on a problem and wanted to read a very specific chunck of file. I read Go documentation and came through [io.LimitReader](http://golang.org/pkg/io/#LimitedReader). According to official documentation, "A LimitedReader reads from R but limits the amount of data returned to just N bytes. Each call to Read updates N to reflect the new amount remaining." and this is what I wanted.

```go

f, _ := os.Open("largefile.bin")
f.Seek(123, 0)

b := make([]byte, 150-123) // remaining length after seek

f.Read(&b)
f.Close()

buf := bytes.NewBuffer(b) // create buffer with the needed bytes

var a float32
binary.Read(buf, binary.LittleEndian, &a)

binary.Read(io.LimitReader(r, 150-123), binary.LittleEndian, &a)
```