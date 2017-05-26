# Flow - Parallelism toolkit

Parallelism is awesome. It should be everywhere. 
Unfortunately, it's hard to do without good tools.

Flow is a toolkit for all your shell parallelism needs.

## Setup
`curl https://raw.githubusercontent.com/swaggy/flow/master/get.sh | sh`

## Usage

### Basic async/await
`flow async <command> <name>`
...
`flow await <name>`

### Group execution
`flow group [<title> <command>, ...]`
