package helloworld

import (
	"fmt"
	"os"
	"strings"
)

// HelloWorldOfArgs prints all command-line arguments joined by spaces.
func HelloWorldOfArgs() {
	args := ""
	if len(os.Args) > 1 {
		args = strings.Join(os.Args[1:], " ")
	}
	fmt.Printf("I see Args: %q\n", args)

	// GitHub Actions output
	setGitHubOutput("argsOutput", args)
}

// HelloWorldOfEnv prints HELLO_WORLD and all HELLO_* environment variables.
func HelloWorldOfEnv() {
	// Print HELLO_WORLD specifically
	envHello := os.Getenv("HELLO_WORLD")
	if envHello == "" {
		envHello = "not set"
	}
	fmt.Printf("I see HELLO_WORLD in the environment: %q\n", envHello)

	// Print all HELLO_* variables
	fmt.Println("Scanning environment for HELLO_* variables:")
	found := false
	for _, e := range os.Environ() {
		pair := strings.SplitN(e, "=", 2)
		key := pair[0]
		value := pair[1]
		if strings.HasPrefix(key, "HELLO_") {
			fmt.Printf("%s=%q\n", key, value)
			found = true
		}
	}
	if !found {
		fmt.Println("No HELLO_* environment variables found.")
	}

	// GitHub Actions output
	setGitHubOutput("envOutput", envHello)
}

// setGitHubOutput writes a key=value pair to $GITHUB_OUTPUT if available
func setGitHubOutput(name, value string) {
	if outFile := os.Getenv("GITHUB_OUTPUT"); outFile != "" {
		f, err := os.OpenFile(outFile, os.O_APPEND|os.O_WRONLY, 0644)
		if err == nil {
			fmt.Fprintf(f, "%s=%s\n", name, value)
			f.Close()
		} else {
			fmt.Printf("Warning: cannot write GitHub output %s: %v\n", name, err)
		}
	}
}
