---
title: "Book Review - Software Engineering at Google: Lessons Learned from Programming Over Time"
description: ""
date: 2020-03-28T09:43:35-05:00
draft: false
tags: [book, review, general]
---

The premise of the book is to draw lessons from software engineering at google and present them in a digestible manner, this book does a good job of that. . Chapters in this book are written by a different people from Google(ex-Google) and that brings a fresh perspective to this book.

The book reintroduces the term engineering with a new definition: programming integrated over time, or how to make software programs stand the test of time. Google use monorepo to host most of their code, This book walks through the tools and trade on how tens of thousands of engineers collaborates across the same codebase.

The first part is relatively short and focuses on Google engineering culture. It
has chapters such as How to work well on team, Knowledge sharing, Leading a
team, and measuring productivity.

The second part is about processes and presents common software development practices, such as Style guides, Code Review, Documentation, and testing. All of the chapters are very well written and gives you an insight on how to apply all the well known practices at scale. 

The last part(Part IV) is about tools used by Googlers to do software Engineering over time. There are chapters about Version Control, Code Search(Really interesting one), Tools to do code reviews and static analysis of code, Dependency Management, and CI/CD. There is so much to learn from these chapters and there is something for all experience level. 

It's a huge book with 551 pages. There is no code in the book as it is about
software engineering and not programming. Every chapter can be read in
isolation(mostly) and this book is going to serve as a reference for me in
future.

Few notable principles from the book - 

* [Hyrum's law](https://www.hyrumslaw.com): With a sufficient number of users of an API,
it does not matter what you promise in the contract: all observable behaviors of your system
will be depended on by somebody.

* Beyonce rule: If you liked it enough, should've put a CI test on it. 

