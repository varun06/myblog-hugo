+++
date = "2014-12-06T19:07:32-06:00"
draft = false
title = "Go lang boiler plate sublime text snippet"

+++

# A sublime Text snippet to auto fill go lang boiler plate

If you work with go lang, you know that every time you write a new go program you have to add some lines of go code that is same most of the time. if you are learning and keep creating small scripts then it gets annoying some time. Sublime text provides an option to create snippets and you can use snippets to auto fill some go lang boiler plate.

```language=go
<snippet>
	<content><![CDATA[
package main

import "fmt"

func main() {
	fmt.Println("${1:// content...}")
}
]]></content>
	<!-- Optional: Set a tabTrigger to define how to trigger the snippet -->
	<tabTrigger>fun</tabTrigger>
	<!-- Optional: Set a scope to limit where the snippet will trigger -->
	<!-- <scope>source.python</scope> -->
</snippet>
```

To add a snippet in Sublime text, Select Tools-> New Snippet from Menu. It will open a new file
in sublime text, paste the above code and make require changes.

Save the snippet and you are all set. Next time when you create a new go file just write "fun" and hit tab, you will have some go lang boiler plate to start with.

This is just a simple snippet, but you can create other complex snippets such as functions, interfaces etc.