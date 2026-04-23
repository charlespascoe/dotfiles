package main

import (
	"fmt"
	"os"
	"os/exec"
)

func main() {
	origMan := os.Getenv("REAL_MAN")
	if origMan == "" {
		panic("REAL_MAN must be set")
	}

	manCmd := exec.Command(origMan, os.Args[1:]...)
	manCmd.Env = append(os.Environ(), "MANPAGER=cat")
	manCmd.Stdin = os.Stdin
	manCmd.Stderr = os.Stderr

	colCmd := exec.Command("col", "-b")
	colCmd.Stdout = os.Stdout
	colCmd.Stderr = os.Stderr

	// Pipe man's stdout into col's stdin.
	pipe, err := manCmd.StdoutPipe()
	if err != nil {
		panic(fmt.Sprintf("create pipe: %v", err))
	}
	colCmd.Stdin = pipe

	// Start both; col must start first so it's reading when man writes.
	if err := colCmd.Start(); err != nil {
		panic(fmt.Sprintf("start col: %v", err))
	}
	if err := manCmd.Start(); err != nil {
		panic(fmt.Sprintf("start man: %v", err))
	}

	// Wait for man first so the pipe gets closed, then col sees EOF.
	manErr := manCmd.Wait()
	colErr := colCmd.Wait()

	if manErr != nil {
		if ec := manCmd.ProcessState.ExitCode(); ec != 0 {
			os.Exit(ec)
		}
		panic(manErr)
	}
	if colErr != nil {
		if ec := colCmd.ProcessState.ExitCode(); ec != 0 {
			os.Exit(ec)
		}
		panic(colErr)
	}
}
