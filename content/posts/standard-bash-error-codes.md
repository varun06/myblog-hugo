+++
categories = ["general", "technical"]
date = "2016-07-03T06:33:31-05:00"
tags = ["general", "blog"]
title = "standard bash error codes"

+++

Exit codes in bash indicate the previous command's termination status. 0 indicates that command completion was successful while 1 indicates that command execution failed.

We can check the exit code generated by last command by using **$?**

```
$ echo $?
```

It's not only 1 that indicates unsuccessful completion, anything greater than 1 is a sign of command failure. Standard error code are listed here:

| Exit Code	| Description	|
| ---------:| ----------: 	|
| 0			| Successful execution|
| 1			| Unsuccessful execution catchall |
| 2 		| Incorrect use of shell builtin |
| 126		| Command can not execute		|
| 127		| Command not Found			|
| 128 		| Incorrect exit code argument |
| 128 + num | Fatal error signal "num"	|
| 130		| Script killed with CTRL + C |
| 255+		| Exit code is out of range	|

Note: Exit code is an integer value between 0 and/or 255.


