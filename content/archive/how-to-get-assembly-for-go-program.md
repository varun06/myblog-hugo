+++
date = "2017-01-02T18:38:12-06:00"
title = "how to see assembly code for a go program"
categories = ["technical", "go"]
tags = ["blog", "go", "assembly"]

+++

[Go](https://golang.org) makes it very easy to look at assembly code for a go program. You can use `go tool compile` or `go build` with `gcflags` to print the assembly on stdout.

```
$ cat hello.go
package main

import "fmt"

func main() {
        fmt.Println("Hello, Assembly!")
}

$ go build -gcflags -S hello.go
# command-line-arguments
"".main t=1 size=179 args=0x0 locals=0x58
        0x0000 00000 (hello.go:5)  TEXT    "".main(SB), $88-0
        0x0000 00000 (hello.go:5)  MOVQ    (TLS), CX
        0x0009 00009 (hello.go:5)  CMPQ    SP, 16(CX)
        0x000d 00013 (hello.go:5)  JLS     169
        0x0013 00019 (hello.go:5)  SUBQ    $88, SP
        0x0017 00023 (hello.go:5)  MOVQ    BP, 80(SP)
        0x001c 00028 (hello.go:5)  LEAQ    80(SP), BP
        0x0021 00033 (hello.go:5)  FUNCDATA        $0, gclocals·69c1753bd5f81501d95132d08af04464(SB)
        0x0021 00033 (hello.go:5)  FUNCDATA        $1, gclocals·e29b39dba2f7b47ee8f21f123fdd2633(SB)
        0x0021 00033 (hello.go:6)  LEAQ    go.string."Hello, Assembly!"(SB), AX
        0x0028 00040 (hello.go:6)  MOVQ    AX, "".autotmp_0+64(SP)
        0x002d 00045 (hello.go:6)  MOVQ    $16, "".autotmp_0+72(SP)
        0x0036 00054 (hello.go:6)  MOVQ    $0, "".autotmp_4+48(SP)
        0x003f 00063 (hello.go:6)  MOVQ    $0, "".autotmp_4+56(SP)
        0x0048 00072 (hello.go:6)  LEAQ    type.string(SB), AX
        0x004f 00079 (hello.go:6)  MOVQ    AX, (SP)
        0x0053 00083 (hello.go:6)  LEAQ    "".autotmp_0+64(SP), AX
        0x0058 00088 (hello.go:6)  MOVQ    AX, 8(SP)
        0x005d 00093 (hello.go:6)  MOVQ    $0, 16(SP)
        0x0066 00102 (hello.go:6)  PCDATA  $0, $1
        0x0066 00102 (hello.go:6)  CALL    runtime.convT2E(SB)
        0x006b 00107 (hello.go:6)  MOVQ    32(SP), AX
        0x0070 00112 (hello.go:6)  MOVQ    24(SP), CX
        0x0075 00117 (hello.go:6)  MOVQ    CX, "".autotmp_4+48(SP)
        0x007a 00122 (hello.go:6)  MOVQ    AX, "".autotmp_4+56(SP)
        0x007f 00127 (hello.go:6)  LEAQ    "".autotmp_4+48(SP), AX
        0x0084 00132 (hello.go:6)  MOVQ    AX, (SP)
        0x0088 00136 (hello.go:6)  MOVQ    $1, 8(SP)
        0x0091 00145 (hello.go:6)  MOVQ    $1, 16(SP)
        0x009a 00154 (hello.go:6)  PCDATA  $0, $1
        0x009a 00154 (hello.go:6)  CALL    fmt.Println(SB)
        0x009f 00159 (hello.go:7)  MOVQ    80(SP), BP
        0x00a4 00164 (hello.go:7)  ADDQ    $88, SP
        0x00a8 00168 (hello.go:7)  RET
        0x00a9 00169 (hello.go:7)  NOP
        0x00a9 00169 (hello.go:5)  CALL    runtime.morestack_noctxt(SB)
        0x00ae 00174 (hello.go:5)  JMP     0
        0x0000 65 48 8b 0c 25 00 00 00 00 48 3b 61 10 0f 86 96  eH..%....H;a....
        0x0010 00 00 00 48 83 ec 58 48 89 6c 24 50 48 8d 6c 24  ...H..XH.l$PH.l$
        0x0020 50 48 8d 05 00 00 00 00 48 89 44 24 40 48 c7 44  PH......H.D$@H.D
        0x0030 24 48 10 00 00 00 48 c7 44 24 30 00 00 00 00 48  $H....H.D$0....H
        0x0040 c7 44 24 38 00 00 00 00 48 8d 05 00 00 00 00 48  .D$8....H......H
        0x0050 89 04 24 48 8d 44 24 40 48 89 44 24 08 48 c7 44  ..$H.D$@H.D$.H.D
        0x0060 24 10 00 00 00 00 e8 00 00 00 00 48 8b 44 24 20  $..........H.D$
        0x0070 48 8b 4c 24 18 48 89 4c 24 30 48 89 44 24 38 48  H.L$.H.L$0H.D$8H
        0x0080 8d 44 24 30 48 89 04 24 48 c7 44 24 08 01 00 00  .D$0H..$H.D$....
        0x0090 00 48 c7 44 24 10 01 00 00 00 e8 00 00 00 00 48  .H.D$..........H
        0x00a0 8b 6c 24 50 48 83 c4 58 c3 e8 00 00 00 00 e9 4d  .l$PH..X.......M
        0x00b0 ff ff ff                                         ...
        rel 5+4 t=15 TLS+0
        rel 36+4 t=14 go.string."Hello, Assembly!"+0
        rel 75+4 t=14 type.string+0
        rel 103+4 t=7 runtime.convT2E+0
        rel 155+4 t=7 fmt.Println+0
        rel 170+4 t=7 runtime.morestack_noctxt+0
"".init t=1 size=61 args=0x0 locals=0x0
        0x0000 00000 (hello.go:8)  TEXT    "".init(SB), $0-0
        0x0000 00000 (hello.go:8)  MOVQ    (TLS), CX
        0x0009 00009 (hello.go:8)  CMPQ    SP, 16(CX)
        0x000d 00013 (hello.go:8)  JLS     54
        0x000f 00015 (hello.go:8)  NOP
        0x000f 00015 (hello.go:8)  NOP
        0x000f 00015 (hello.go:8)  FUNCDATA        $0, gclocals·33cdeccccebe80329f1fdbee7f5874cb(SB)
        0x000f 00015 (hello.go:8)  FUNCDATA        $1, gclocals·33cdeccccebe80329f1fdbee7f5874cb(SB)
        0x000f 00015 (hello.go:8)  MOVBLZX "".initdone·(SB), AX
        0x0016 00022 (hello.go:8)  CMPB    AL, $1
        0x0018 00024 (hello.go:8)  JLS     $0, 27
        0x001a 00026 (hello.go:8)  RET
        0x001b 00027 (hello.go:8)  JNE     $0, 34
        0x001d 00029 (hello.go:8)  PCDATA  $0, $0
        0x001d 00029 (hello.go:8)  CALL    runtime.throwinit(SB)
        0x0022 00034 (hello.go:8)  MOVB    $1, "".initdone·(SB)
        0x0029 00041 (hello.go:8)  PCDATA  $0, $0
        0x0029 00041 (hello.go:8)  CALL    fmt.init(SB)
        0x002e 00046 (hello.go:8)  MOVB    $2, "".initdone·(SB)
        0x0035 00053 (hello.go:8)  RET
        0x0036 00054 (hello.go:8)  NOP
        0x0036 00054 (hello.go:8)  CALL    runtime.morestack_noctxt(SB)
        0x003b 00059 (hello.go:8)  JMP     0
        0x0000 65 48 8b 0c 25 00 00 00 00 48 3b 61 10 76 27 0f  eH..%....H;a.v'.
        0x0010 b6 05 00 00 00 00 3c 01 76 01 c3 75 05 e8 00 00  ......<.v..u....
        0x0020 00 00 c6 05 00 00 00 00 01 e8 00 00 00 00 c6 05  ................
        0x0030 00 00 00 00 02 c3 e8 00 00 00 00 eb c3           .............
        rel 5+4 t=15 TLS+0
        rel 18+4 t=14 "".initdone·+0
        rel 30+4 t=7 runtime.throwinit+0
        rel 36+4 t=14 "".initdone·+-1
        rel 42+4 t=7 fmt.init+0
        rel 48+4 t=14 "".initdone·+-1
        rel 55+4 t=7 runtime.morestack_noctxt+0
go.string.hdr."Hello, Assembly!" t=9 dupok size=16
        0x0000 00 00 00 00 00 00 00 00 10 00 00 00 00 00 00 00  ................
        rel 0+8 t=1 go.string."Hello, Assembly!"+0
go.string."Hello, Assembly!" t=9 dupok size=16
        0x0000 48 65 6c 6c 6f 2c 20 41 73 73 65 6d 62 6c 79 21  Hello, Assembly!
gclocals·e29b39dba2f7b47ee8f21f123fdd2633 t=9 dupok size=16
        0x0000 02 00 00 00 04 00 00 00 00 00 00 00 07 00 00 00  ................
gclocals·69c1753bd5f81501d95132d08af04464 t=9 dupok size=8
        0x0000 02 00 00 00 00 00 00 00                          ........
gclocals·33cdeccccebe80329f1fdbee7f5874cb t=9 dupok size=8
        0x0000 01 00 00 00 00 00 00 00                          ........
"".initdone· t=34 size=1
"".main·f t=9 dupok size=8
        0x0000 00 00 00 00 00 00 00 00                          ........
        rel 0+8 t=1 "".main+0
"".init·f t=9 dupok size=8
        0x0000 00 00 00 00 00 00 00 00                          ........
        rel 0+8 t=1 "".init+0
runtime.gcbits.03 t=9 dupok size=1
        0x0000 03                                               .
type..namedata.*interface {}. t=9 dupok size=16
        0x0000 00 00 0d 2a 69 6e 74 65 72 66 61 63 65 20 7b 7d  ...*interface {}
type.interface {} t=9 dupok size=80
        0x0000 10 00 00 00 00 00 00 00 10 00 00 00 00 00 00 00  ................
        0x0010 e7 57 a0 18 02 08 08 14 00 00 00 00 00 00 00 00  .W..............
        0x0020 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        0x0030 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        0x0040 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        rel 24+8 t=1 runtime.algarray+144
        rel 32+8 t=1 runtime.gcbits.03+0
        rel 40+4 t=5 type..namedata.*interface {}.+0
        rel 56+8 t=1 type.interface {}+80
runtime.gcbits.01 t=9 dupok size=1
        0x0000 01                                               .
type..namedata.*[]interface {}. t=9 dupok size=18
        0x0000 00 00 0f 2a 5b 5d 69 6e 74 65 72 66 61 63 65 20  ...*[]interface
        0x0010 7b 7d                                            {}
type.[]interface {} t=9 dupok size=56
        0x0000 18 00 00 00 00 00 00 00 08 00 00 00 00 00 00 00  ................
        0x0010 70 93 ea 2f 02 08 08 17 00 00 00 00 00 00 00 00  p../............
        0x0020 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        0x0030 00 00 00 00 00 00 00 00                          ........
        rel 24+8 t=1 runtime.algarray+0
        rel 32+8 t=1 runtime.gcbits.01+0
        rel 40+4 t=5 type..namedata.*[]interface {}.+0
        rel 48+8 t=1 type.interface {}+0
go.typelink.[]interface {} t=9 dupok size=4
        0x0000 00 00 00 00                                      ....
        rel 0+4 t=5 type.[]interface {}+0
type..namedata.*[1]interface {}. t=9 dupok size=19
        0x0000 00 00 10 2a 5b 31 5d 69 6e 74 65 72 66 61 63 65  ...*[1]interface
        0x0010 20 7b 7d                                          {}
type.[1]interface {} t=9 dupok size=72
        0x0000 10 00 00 00 00 00 00 00 10 00 00 00 00 00 00 00  ................
        0x0010 50 91 5b fa 02 08 08 11 00 00 00 00 00 00 00 00  P.[.............
        0x0020 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        0x0030 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        0x0040 01 00 00 00 00 00 00 00                          ........
        rel 24+8 t=1 runtime.algarray+144
        rel 32+8 t=1 runtime.gcbits.03+0
        rel 40+4 t=5 type..namedata.*[1]interface {}.+0
        rel 48+8 t=1 type.interface {}+0
        rel 56+8 t=1 type.[]interface {}+0
go.typelink.[1]interface {} t=9 dupok size=4
        0x0000 00 00 00 00                                      ....
        rel 0+4 t=5 type.[1]interface {}+0
type.*[1]interface {} t=9 dupok size=56
        0x0000 08 00 00 00 00 00 00 00 08 00 00 00 00 00 00 00  ................
        0x0010 bf 03 a8 35 00 08 08 36 00 00 00 00 00 00 00 00  ...5...6........
        0x0020 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        0x0030 00 00 00 00 00 00 00 00                          ........
        rel 24+8 t=1 runtime.algarray+80
        rel 32+8 t=1 runtime.gcbits.01+0
        rel 40+4 t=5 type..namedata.*[1]interface {}.+0
        rel 48+8 t=1 type.[1]interface {}+0
go.typelink.*[1]interface {} t=9 dupok size=4
        0x0000 00 00 00 00                                      ....
        rel 0+4 t=5 type.*[1]interface {}+0
type..importpath.fmt. t=9 dupok size=6
        0x0000 00 00 03 66 6d 74                                ...fmt
```

For detailed info, read [A Quick Guide to Go's Assembler](https://golang.org/doc/asm).
