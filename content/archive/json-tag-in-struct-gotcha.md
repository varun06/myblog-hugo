+++
date = "2015-10-19T19:58:28-06:00"
draft = false
title = "Issue with white space in json struct tags"
+++

Go requires all exported fields to start with a capitalized letter. But It is not common for JSON where lower case letter keys are preferred. We can solve this problem by using the struct tags for json.

for an example: 

<pre>
type MyStruct struct {
    SomeField string `json:"some_field"`
}
</pre>

According to [Golang spec](https://golang.org/ref/spec#Struct_types)
<blockquote>
A field declaration may be followed by an optional string literal tag, which becomes an attribute for all the fields in the corresponding field declaration. The tags are made visible through a reflection interface and take part in type identity for structs but are otherwise ignored.
</blockquote>

But be careful when you create json tags. If there is any white space in json tag, struct will not be unMarshaled properly. If you have a struct such as:

<pre>
type MyStruct struct {
	Foo string `json: "foo"`
}
</pre>

When you unmarshal a json string to `MyStruct` type, it will give you zero value (empty string for a string). This is also very difficult to catch.
