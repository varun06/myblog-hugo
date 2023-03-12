---
title: "Guessing Game from Rust book in  Go"
description: "converting guessing game from rust book to go"
date: 2022-09-11T07:31:09-05:00
draft: false
tags: ["go", "rust", "programming", "learning"]
---

This year I have been finding some time and learning Rust. I am going to write about my learning journey in another post. Today I want to talk about converting Guessing game from Rust book to Go. It was a fun and quick exercise. It's interesting to see that both programms are almost same in size. Here is [Rust code](https://doc.rust-lang.org/book/ch02-00-guessing-game-tutorial.html) from **Book**.

```Rust
use std::io;
use rand::Rng;
use std::cmp::Ordering;

fn main() {
	println!("Guess the number!!");

	let secret_number = rand::thread_rng().gen_range(1..=100);

	loop {
		println!("Please input your guess.");

		let mut guess = String::new();

		io::stdin()
			.read_line(&mut guess)
			.expect("Failed to read line");

		let guess: u32 = match guess.trim().parse(){
				Ok(num) => num,
				Err(_) => continue,
			};

		println!("You guessed: {guess}");

		match guess.cmp(&secret_number) {
			Ordering::Less => println!("Too small!"),
			Ordering::Greater => println!("Too big!"),
			Ordering::Equal => {
				println!("You win!");
				break;
			}
		}
	}
}
```

And here is my interpretation in Go.

```Go
package main

import (
	"bufio"
	"fmt"
	"log"
	"math/rand"
	"os"
	"strconv"
	"strings"
	"time"
)

func main() {
	fmt.Println("Guess the number!!")

	rand.Seed(time.Now().UnixNano())
	secretNumber := rand.Int63n(100)

	for {
		reader := bufio.NewReader(os.Stdin)
		fmt.Print("Enter text: ")
		text, err := reader.ReadString('\n')
		if err != nil {
			log.Fatal(err)
		}
		fmt.Println("You guessed: ", text)

		guess, err := strconv.ParseInt(strings.Trim(text, "\n"), 10, 64)
		if err != nil {
			log.Fatal(err)
		}

		if guess < secretNumber {
			fmt.Println("Too small!!")
		} else if guess > secretNumber {
			fmt.Println("Too big!!")
		} else if guess == secretNumber {
			fmt.Println("You win!")
			break
		}
	}
}
```

They both have almost same lines of codes and readable at the same time.
