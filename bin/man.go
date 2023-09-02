package main

import (
	"os"
	"os/exec"
)

func main() {
	origMan := os.Getenv("REAL_MAN")

	if origMan == "" {
		panic("REAL_MAN must be set")
	}

	args := os.Args[1:]

	cmd := exec.Command(origMan, args...)

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
