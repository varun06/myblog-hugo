+++
categories = ["general","technical", "go"]
tags = ["go","blog", "TIL"]
date = "2016-12-28T14:29:42-06:00"
title = "var block changed to init function in assembly"

+++

TIL - [go](https://golang.org) turns a var block in init function behind the scenes.

```
package main

import "fmt"

var (
	testError1 = fmt.Errorf("%s ", "I am error one")
	testError2 = fmt.Errorf("%s ", "I am error two")
)

func main() {}
```
So if you look at the assembly code below, you will see that we have `.main` and `.init`. `.init` function has `0x0049 00073 (/Users/vakumar/temp/test.go:6)    LEAQ    go.string."I am error one"(SB), AX` which is in `var block` in my go code above. 

```
"".main t=1 size=1 args=0x0 locals=0x0
        0x0000 00000 (/Users/vakumar/temp/test.go:10)   TEXT    "".main(SB), $0-0
        0x0000 00000 (/Users/vakumar/temp/test.go:10)   NOP
        0x0000 00000 (/Users/vakumar/temp/test.go:10)   NOP
        0x0000 00000 (/Users/vakumar/temp/test.go:10)   FUNCDATA        $0, gclocals·33cdeccccebe80329f1fdbee7f5874cb(SB)
        0x0000 00000 (/Users/vakumar/temp/test.go:10)   FUNCDATA        $1, gclocals·33cdeccccebe80329f1fdbee7f5874cb(SB)
        0x0000 00000 (/Users/vakumar/temp/test.go:10)   RET
        0x0000 c3                                               .
"".init t=1 size=605 args=0x0 locals=0x70
        0x0000 00000 (/Users/vakumar/temp/test.go:11)   TEXT    "".init(SB), $112-0
        0x0000 00000 (/Users/vakumar/temp/test.go:11)   MOVQ    (TLS), CX
        0x0009 00009 (/Users/vakumar/temp/test.go:11)   CMPQ    SP, 16(CX)
        0x000d 00013 (/Users/vakumar/temp/test.go:11)   JLS     595
        0x0013 00019 (/Users/vakumar/temp/test.go:11)   SUBQ    $112, SP
        0x0017 00023 (/Users/vakumar/temp/test.go:11)   MOVQ    BP, 104(SP)
        0x001c 00028 (/Users/vakumar/temp/test.go:11)   LEAQ    104(SP), BP
        0x0021 00033 (/Users/vakumar/temp/test.go:11)   FUNCDATA        $0, gclocals·3e27b3aa6b89137cce48b3379a2a6610(SB)
        0x0021 00033 (/Users/vakumar/temp/test.go:11)   FUNCDATA        $1, gclocals·3672590320383b7a4beab9e3e42e1c00(SB)
        0x0021 00033 (/Users/vakumar/temp/test.go:11)   MOVBLZX "".initdone·(SB), AX
        0x0028 00040 (/Users/vakumar/temp/test.go:11)   CMPB    AL, $1
        0x002a 00042 (/Users/vakumar/temp/test.go:11)   JLS     $0, 54
        0x002c 00044 (/Users/vakumar/temp/test.go:11)   MOVQ    104(SP), BP
        0x0031 00049 (/Users/vakumar/temp/test.go:11)   ADDQ    $112, SP
        0x0035 00053 (/Users/vakumar/temp/test.go:11)   RET
        0x0036 00054 (/Users/vakumar/temp/test.go:11)   JNE     $0, 61
        0x0038 00056 (/Users/vakumar/temp/test.go:11)   PCDATA  $0, $0
        0x0038 00056 (/Users/vakumar/temp/test.go:11)   CALL    runtime.throwinit(SB)
        0x003d 00061 (/Users/vakumar/temp/test.go:11)   MOVB    $1, "".initdone·(SB)
        0x0044 00068 (/Users/vakumar/temp/test.go:11)   PCDATA  $0, $0
        0x0044 00068 (/Users/vakumar/temp/test.go:11)   CALL    fmt.init(SB)
        0x0049 00073 (/Users/vakumar/temp/test.go:6)    LEAQ    go.string."I am error one"(SB), AX
        0x0050 00080 (/Users/vakumar/temp/test.go:6)    MOVQ    AX, "".autotmp_0+88(SP)
        0x0055 00085 (/Users/vakumar/temp/test.go:6)    MOVQ    $14, "".autotmp_0+96(SP)
        0x005e 00094 (/Users/vakumar/temp/test.go:6)    LEAQ    type.[1]interface {}(SB), AX
        0x0065 00101 (/Users/vakumar/temp/test.go:6)    MOVQ    AX, (SP)
        0x0069 00105 (/Users/vakumar/temp/test.go:6)    PCDATA  $0, $1
        0x0069 00105 (/Users/vakumar/temp/test.go:6)    CALL    runtime.newobject(SB)
        0x006e 00110 (/Users/vakumar/temp/test.go:6)    MOVQ    8(SP), AX
        0x0073 00115 (/Users/vakumar/temp/test.go:6)    MOVQ    AX, "".autotmp_8+64(SP)
        0x0078 00120 (/Users/vakumar/temp/test.go:6)    LEAQ    type.string(SB), CX
        0x007f 00127 (/Users/vakumar/temp/test.go:6)    MOVQ    CX, (SP)
        0x0083 00131 (/Users/vakumar/temp/test.go:6)    LEAQ    "".autotmp_0+88(SP), DX
        0x0088 00136 (/Users/vakumar/temp/test.go:6)    MOVQ    DX, 8(SP)
        0x008d 00141 (/Users/vakumar/temp/test.go:6)    MOVQ    $0, 16(SP)
        0x0096 00150 (/Users/vakumar/temp/test.go:6)    PCDATA  $0, $2
        0x0096 00150 (/Users/vakumar/temp/test.go:6)    CALL    runtime.convT2E(SB)
        0x009b 00155 (/Users/vakumar/temp/test.go:6)    MOVQ    32(SP), AX
        0x00a0 00160 (/Users/vakumar/temp/test.go:6)    MOVQ    24(SP), CX
        0x00a5 00165 (/Users/vakumar/temp/test.go:6)    MOVQ    "".autotmp_8+64(SP), DX
        0x00aa 00170 (/Users/vakumar/temp/test.go:6)    MOVQ    CX, (DX)
        0x00ad 00173 (/Users/vakumar/temp/test.go:6)    MOVL    runtime.writeBarrier(SB), CX
        0x00b3 00179 (/Users/vakumar/temp/test.go:6)    TESTB   CL, CL
        0x00b5 00181 (/Users/vakumar/temp/test.go:6)    JNE     $0, 567
        0x00bb 00187 (/Users/vakumar/temp/test.go:6)    MOVQ    AX, 8(DX)
        0x00bf 00191 (/Users/vakumar/temp/test.go:6)    LEAQ    go.string."%s "(SB), AX
```
