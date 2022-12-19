package main

import (
	"os"
	"os/exec"
)

func main() {
	cmd := exec.Command("/usr/bin/man", os.Args[1:]...)
	cmd.Env = append(os.Environ(), "MAN=1")
	cmd.Stdin = os.Stdin
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	if err := cmd.Run(); err != nil {
		panic(err)
	}
}
