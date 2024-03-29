+++
date = "2015-05-31T06:30:00-06:00"
draft = false
title = "using io.SectionReader in Go"
+++

For my last task I was moving to an offset value in huge byte stream using `reader.Seek(int64(offset), whence)` and reading the bytes there. But it was not good for the performance because I was moving in a big file(~1gigs). Then I came to know about `io.SectionReader` and it made my life easier and helped me delete a lot of code(isn't that best).

I create the section reader using this function:

```go
func GetByteSection(pageBlock []byte, offset int64, sectionLength int64) *io.SectionReader {
 reader := bytes.NewReader(pageBlock)
 section := io.NewSectionReader(reader, offset, sectionLength)
 return section
}
```

Then I read it like:

```go
tupleSection := GetByteSection(block, int64(headerOffset), int64(headerLength))
err = binary.Read(tupleSection, binary.LittleEndian, &data)
if err != nil {
 return nil, fmt.Errorf("failed to read t_bits: %v\n", err)
}
```

life has been easier with more [sectionReader](http://golang.org/pkg/io/#SectionReader) and less Seeks.
