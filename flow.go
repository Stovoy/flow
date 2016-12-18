package main

import (
	"flag"
	"fmt"
	"os"
	"os/exec"
	"syscall"
)

const (
	usageOverall = `Usage: flow <cmd> [<args>...]

Commands:
  async       Run a command in the background. Use with await.
  await       Wait for an async command to complete.
  group       Runs a group of commands and waits for their completion.`
)

var usageCommand = map[string]string{
	"async": `Usage: flow async <command to execute> [name]

If given name, the command can be awaited with that name.
Returns the pid of the command, which can be used if name is not specified.
`,
	"await": `Usage: flow await <id>

The id of a command can be the pid returned from flow async or the specified name.`,

	"group": `Usage: flow group [<title> <command>, ...]

Each command needs a title, so there must be an even number of arguments.`,
}

func main() {
	flag.Usage = usage

	flags := flag.NewFlagSet(os.Args[0], flag.ContinueOnError)

	err := flags.Parse(os.Args[1:])
	if err != nil && err != flag.ErrHelp {
		fmt.Println(err)
		usage()
		os.Exit(1)
	}

	if flags.NArg() < 1 {
		usage()
		os.Exit(1)
	}

	if flags.NArg() < 1 {
		usage()
		os.Exit(1)
	}

	command := flags.Arg(0)
	if command == "help" {
		usage()
		os.Exit(0)
	}

	var args []string
	if flags.NArg() > 1 {
		args = flags.Args()[1:]
		if args[0] == "help" {
			commandUsage(command)
			os.Exit(0)
		}
	}
	if _, ok := usageCommand[command]; !ok {
		usage()
		fmt.Printf("Usage error: Command %s does not exist.\n", command)
		os.Exit(1)
	}

	call(command, args)
}

func usage() {
	fmt.Println(usageOverall)
}

func commandUsage(command string) {
	fmt.Println(usageCommand[command])
}

func call(command string, args []string) {
	command = ".flow-" + command
	cmd := exec.Command(command, args...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	if err := cmd.Start(); err != nil {
		fmt.Printf("Command start failed: %v\n", err)
		os.Exit(1)
	}

	if err := cmd.Wait(); err != nil {
		if exitErr, ok := err.(*exec.ExitError); ok {
			if status, ok := exitErr.Sys().(syscall.WaitStatus); ok {
				os.Exit(status.ExitStatus())
			}
		} else {
			fmt.Printf("Command execution failed: %v\n", err)
		}
	}
}
