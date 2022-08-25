---
title: "How to make VScode Go work in a Multi-Module Repo"
description: ""
date: 2021-02-06T15:02:43-06:00
draft: false
tags: [go, vscode, gopls]
---

At work, We have a multi-module(nested go modules) repo and VSCode is always having problem with that. I was chatting with gopls team on slack and came to know about a new feature that helps with multi-module and VSCode + Go.

There are 2 ways to fix this issue in VSCode Go extension -

## Multiple modules

if you have multiple modules or nested modules in a single repo, you will need to create a "workspace folder" for each module.

## Workspace module (experimental)

If you want to work with all the nested modules in a single workspace, there is an opt-in module feature that allows to work with multiple modules without creating workspace folders for each module. Set this in your settings -

```go
"build.experimentalWorkspaceModule": true
```

More information about this feature is available at official `gopls` [documentation](https://github.com/golang/tools/blob/master/gopls/doc/workspace.md).
