package main

import (
	"os"
	"os/exec"
)

func main() {
	origOpencode := os.Getenv("REAL_OPENCODE")

	if origOpencode == "" {
		panic("REAL_OPENCODE must be set")
	}

	args := os.Args[1:]

	if _, err := os.Stat("go.mod"); err == nil {
		args = append([]string{"--agent", "go-dev"}, args...)
	}

	cmd := exec.Command(origOpencode, args...)

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
