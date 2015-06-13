+++
date = "2015-06-13T11:11:00-09:00"
draft = false
title = "My Go Lang Development Workflow"

+++

I have been doing programming in Go from last 6 months. When you start a new project or start learning a new programming language, chossing your tools(text editor, plugins etc.) is as important as any other process.

I use Sublime Text 3 with [go-sublime](https://github.com/DisposaBoy/GoSublime) plugin as my text editor. go-sublime adds many features to Sublime Text for go development and make the whole development process a little easier. I particularly like 'go linting' and 'go to definition'.

<br>
<img src="/img/sublime.png" alt="Sublime Text" title="Sublime Text" style="width:700px; height: 500px;">
<br>

Once I have written the code and tests, I run `go test` in terminal (I use iterm2 instead of default terminal app) to test my code. To check code coverage, I run `go test -cover`.

because sometime you need more than one terminal window, I use [tmux](http://tmux.github.io/) for that. tmux manages terminal windows and sessions. I started using tmux some time back and it is great.

OSX window management is a pain in itself, I use [DIVVY](http://mizage.com/divvy/) to manage the windows. I am looking forward to [OSX el capitan](http://www.apple.com/osx/elcapitan-preview/), which has window management build in the OSX (finally).

Once I have tested my code thoroughly on my local machine, I send it to github for code review. I generally use git in terminal to run all the common git commands (such as `git status`, `git commit`, and `git push`).

We use [GRIM](http://github.com/MediaMath/grim), which is open sourced by the way, as our build server. So when I create a pull request for code review, grim takes the pull request and run the build to make sure that everything works as expected with new code, grim also updates the hipchat channel, so that team is aware about new pull request.

This continous build system gives code reviewers a test run even before reviewing the code. Once the code review is done and thumpsup are given, code is ready to be merged in master.

Once merged, time for next task and more Go code/learnings..

Note: If you are a vim user, then [vim-go](https://github.com/fatih/vim-go) is an awesome go plugin for vim.
