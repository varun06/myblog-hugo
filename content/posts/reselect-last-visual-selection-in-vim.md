---
title: "Reselect Last Visual Selection in Vim"
description: ""
date: 2020-06-06T06:01:30-05:00
tags: [vim, visual-mode]
---

Vim has three different visual modes to work with characters, lines, or
rectangle blocks of text. We can switch between these modes by pressing `v`,
`V`, or `<ctrl-v>` respectively. 

Many a times, we select something and press `ESC` by mistake, it is annoying to
reselect the whole block of text again by pressing `v/V`. Vim provides a command
`gv` to reselect the range of text that was selected. Command `gv` works for all
the visual modes. 
