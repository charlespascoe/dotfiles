package main

import (
	"os"
	"os/exec"
)

func main() {
	origPi := os.Getenv("REAL_PI")

	if origPi == "" {
		panic("REAL_PI must be set")
	}

	args := os.Args[1:]

	cmd := exec.Command(origPi, args...)

	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Stdin = os.Stdin

	if err := cmd.Run(); err != nil {
		ec := cmd.ProcessState.ExitCode()
		if ec != 0 {
			os.Exit(ec)
		} else {
			panic(err)
		}
	}
}
