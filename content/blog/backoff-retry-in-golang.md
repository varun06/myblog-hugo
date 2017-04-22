+++
categories = ["go"]
date = "2017-04-16T08:01:00-05:00"
description = "retry and backoff in go"
tags = ["go", "retry", "backoff"]
title = "backoff and  retry in go"

+++

Failure is a way of life. Requests(http or others..) can fail for many reasons. Decision to stop or retry can be very critical for applications. backoff algorithms provide a way to backoff and retry on a failure. There are two popular methods to backoff, constant backoff and exponential backoff.

I use [backoff](https://github.com/cenkalti/backoff) library, which is a [Go](https://golang.org) port of exponential backoff algorithm from [Google's HTTP Client Library for Java](https://github.com/google/google-http-java-client).

[backoff](https://github.com/cenkalti/backoff) provides 4 main functionalities. [Constant Backoff](https://godoc.org/github.com/cenkalti/backoff#BackOffContext), [Exponential Backoff](https://godoc.org/github.com/cenkalti/backoff#ExponentialBackOff), [Retry](https://godoc.org/github.com/cenkalti/backoff#Retry), and [Retry with Notify](https://godoc.org/github.com/cenkalti/backoff#RetryNotify)

Based on application needs, we can use either constant backoff or exponential backoff. Here are some examples of both.

## Constant Backoff: 

Constant BackOff is a backoff policy that always returns the same backoff delay. 

```

package main

import "github.com/cenkalti/backoff"

func main(){
	b := backoff.NewConstantBackOff(1*time.Second)
	err = backoff.Retry(doSomething(), b)
	if err != nil{
		log.Fatalf("error after retrying: %v", err)
	}
}

func doSomething() error {
	//do something and return error
	var err error
	return err
}

```

## Exponential BackOff:

ExponentialBackOff is a backoff implementation that increases the backoff period for each retry attempt using a randomization function that grows exponentially.

```

package main

import "github.com/cenkalti/backoff"

func main(){
	b := backoff.NewExponentialBackOff()
	b.MaxElapsedTime = 3 *time.Minute

	err = backoff.Retry(doSomething(), b)
	if err != nil{
		log.Fatalf("error after retrying: %v", err)
	}
}

func doSomething() error {
	//do something and return error
	var err error
	return err
}

```

That is fine but what if your function returns a tuple of value and error and you also want to log the initial errors. How do you retry that function using backoff library.

## Exponential BackOff with notify:

```
package main

import "github.com/cenkalti/backoff"

func main(){
	b := backoff.NewExponentialBackOff()
	b.MaxElapsedTime = 3 *time.Minute

	var (
		var int64
		err error
	)

	retryable := func() error {
		val, err = doSomething()
	}

	notify := func(err error, t time.Duration){
		log.Printf("error: %v happened at time: %v", err, t)
	}

	err = backoff.RetryNotify(retryable, b, notify)
	if err != nil{
		log.Fatalf("error after retrying: %v", err)
	}
}

func doSomething() (int64, error) {
	return 6, nil
}

```
