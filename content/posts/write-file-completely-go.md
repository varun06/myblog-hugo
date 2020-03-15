+++
categories = ["go"]
date = "2017-06-27T08:01:00-05:00"
description = "one way to write files completely to disk in go"
tags = ["go", "file", "write"]
title = "writing files completely to disk in go"

+++

When we write a file, how we make sure that file is written completely to disk. One of the way is write a **temporary** file first and then rename it, rename operation is atomic, so we get a complete file.

```
tempFile, err := ioutil.TempFile(path, name)
if err != nil {
    return err
}
defer tempFile.Close()

tempname := tempFile.Name()
defer os.Remove(tempname)

//Write to temp file

err = os.Rename(tempname, filename)
if err != nil {
    return err
}
``` 