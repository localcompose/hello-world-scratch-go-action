package main

import (
	"fmt"

	"github.com/localcompose/hello-world-scratch-go-action/internal/cmd/helloworld"
)

func main() {
	fmt.Println("Hello, world!")
	helloworld.HelloWorldOfArgs()
	helloworld.HelloWorldOfEnv()
}
