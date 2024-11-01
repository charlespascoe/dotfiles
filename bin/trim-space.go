package main

import (
    "os"
    "io"
    "strings"
)

func main() {
    input, err := io.ReadAll(os.Stdin)
    if err != nil {
        panic(err)
    }

    output := strings.TrimSpace(string(input))

    _, err = os.Stdout.WriteString(output)
    if err != nil {
        panic(err)
    }
}
