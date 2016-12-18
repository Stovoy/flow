#!/bin/bash -e

flow() {
    if [[ "$#" == 0 ]]; then
        usage
        exit 1
    fi

    local command=$1
    if [[ $command == "help" ]]; then
        usage
        exit 0
    fi

    if [[ $command_list != *"$command"* ]]; then
        usage
        echo "Usage error: Command $command does not exist."
        exit 1
    fi

    if [[ $# -ge 1 ]]; then
        if [[ $2 == "help" ]]; then
            usage_command $command
            exit 0
        fi
    fi

    call "$@"
}

call() {
	local command="./commands/$1.sh"
    if [[ ! -e $command ]]; then
        command=".flow-$1"
        if ! which $command; then
            echo "Could not find command $1."
            exit 1
        fi
    fi

	shift
    local args=()
    for arg in "$@"; do
        args+=("$arg")
    done
	$command "${args[@]}"
}

usage() {
    echo "Usage: flow <cmd> [<args>...]

Commands:
  async       Run a command in the background. Use with await.
  await       Wait for an async command to complete.
  group       Runs a group of commands and waits for their completion."
}

command_list="async await group"
usage_command() {
    command=$1
    case $command in
        "async") echo "Usage: flow async <command to execute> [name]

If given name, the command can be awaited with that name.
Returns the pid of the command, which can be used if name is not specified."
    ;;

        "await") echo "Usage: flow await <id>

    The id of a command can be the pid returned from flow async or the specified name."
    ;;

        "group") echo "Usage: flow group [<title> <command>, ...]

    Each command needs a title, so there must be an even number of arguments."
    ;;
    esac
}

flow "$@"
