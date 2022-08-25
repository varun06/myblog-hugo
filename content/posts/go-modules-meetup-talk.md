---
title: "Go Modules Meetup Talk"
description: ""
date: 2021-04-18T07:14:06-05:00
draft: false
tags: [go, modules, meetup, speaking]
---

I go a chance to speak at [Go Banglore meetup](https://www.meetup.com/Golang-Bangalore/events/277149305/) recently. My talk was about how we moved from custom dependecy management to `go modules` at work.

## Go at Walmart

- Go is used at edge and many other places in Walmart
- Edge Foundation - CDN and Proxies
- There are more than 400 repositories in our github organization

## Quirks before go modules

- Most of code in one single repo
- Module incompatible import paths("torbit/foo)
- Big utilities packages that are shared around teams 
- Forks of popular open source repositories
- Mix of monorepo and multi-repo


## Custom dependency manager tool - tbget

- Clone repository locally
- Run tbget ./... to fetch dependencies and store them in gopath
- Make changes and test/build


## Problems with Monorepo

- House of 10-12 critical services in edge foundation
- No clear ownership across services
- Slow builds because of lack of tooling and huge number of tests(15-20 minutes to run a build)
- Big surface area for failures and issues

# Deconstructing the Monorepo


## Form a team

- Form a team of like minded people, 
- Glad I found Pedro, Troy and few other folks who helped with this task
- Break the problem in small and manageable chunks
- Move go repositories to go modules one by one


## Find your go dependency and packages

[goda](https://github.com/loov/goda)

## For packages that need to move out

- Create a repository and go module if required
- Change imports(from torbit/fsnotify -> github.com/fsnotify/fsnotify) 
- Make pull requests
- Find a suitable time to make a change(Code freeze for us)
- Success

## How about git history

- Commit messages and history should be preserved
- git-filter-repo can refactor directories and rewrite git histories
    > git filter-repo --path src/ --to-subdirectory-filter my-module --tag-rename '':'my-module-'

https://github.com/newren/git-filter-repo

## What about technical debt

- We tried to pay tech debt where it was okay
- My suggestion is to keep it simple
- linting/vetting is easy to get done in same cycle
- but keep them in different pull requests

## Improvements

- only `go` and `git` required to start developing
- Trade homegrown dependency management with *go modules*
- No need to learn a custom tool to manage dependencies
- Fewer failures in builds 
- Faster builds because of small surface area
- Clear line of ownership across teams and projects

## Lessons learned

- Properly manage external dependencies
- Stay away from kitchen sink or util packages
- A little copy is better than a dependency

## Current challenges

- Nested go modules and keeping mods in sync
- VPN and downloading public modules from internet(some domains are blocked)
- We have tried vendoring dependencies but decided against using it

## Future Improvements

- Setup a Go Proxy
- Move nested go modules out whenever we can
