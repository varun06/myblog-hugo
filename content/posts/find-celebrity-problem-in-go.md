---
title: "Find Celebrity Problem in Go"
date: 2019-01-26T11:56:37-06:00
---

# Problem Statement

>Suppose you are at a party with n people (labeled from 0 to n - 1) and among them, there may exist one celebrity. The definition of a celebrity is that all the other n - 1 people know him/her but he/she does not know any of them.
>Now you want to find out who the celebrity is or verify that there is not one. The only thing you are allowed to do is to ask questions like: "Hi, A. Do you know B?" to get information of whether A knows B. You need to find out the celebrity (or verify there is not one) by asking as few questions as possible (in the asymptotic sense).
>You are given a helper function bool knows(a, b) which tells you whether A knows B. Implement a function int findCelebrity(n), your function should minimize the number of calls to knows.
>Note: There will be exactly one celebrity if he/she is in the party. Return the celebrity's label if there is a celebrity in the party. If there is no celebrity, return -1.Suppose you are at a party with n people (labeled from 0 to n - 1) and among them, there may exist one celebrity. The definition of a celebrity is that all the other n - 1 people know him/her but he/she does not know any of them.
>Now you want to find out who the celebrity is or verify that there is not one. The only thing you are allowed to do is to ask questions like: "Hi, A. Do you know B?" to get information of whether A knows B. You need to find out the celebrity (or verify there is not one) by asking as few questions as possible (in the asymptotic sense).
>You are given a helper function bool knows(a, b) which tells you whether A knows B. Implement a function int findCelebrity(n), your function should minimize the number of calls to knows.
>Note: There will be exactly one celebrity if he/she is in the party. Return the celebrity's label if there is a celebrity in the party. If there is no celebrity, return -1.

***

Some things that we can deduce from problem statement -

1. There is only one celebrity and every other person in the party knows this celebrity.
2. Celebrity doesn't know anyone in party.

Now we have to find a person who is known by most of the people and then confirm this person fits all the point above.

```go

import "fmt"

//We can also make it a boolean matrix
var matrix = [8][8]int{
	{0, 0, 1, 0},
	{0, 0, 1, 0},
	{0, 0, 0, 0},
	{0, 0, 1, 0},
}

func main() {
	n := 4
	fmt.Println(findCelebrity(n))
}

func knows(a, b int) bool {
	if matrix[a][b] == 0 {
		return false
	}
	return true
}

func findCelebrity(n int) int {
	celeb := 0
	for i := 0; i < n; i++ {
		if knows(celeb, i) {
			celeb = i
		}
	}

	for i := 0; i < n; i++ {
		if i != celeb && (knows(celeb, i) || !knows(i, celeb)) {
			return -1
		}
	}
	return celeb
}

```

This is a linear time solution O(n).
