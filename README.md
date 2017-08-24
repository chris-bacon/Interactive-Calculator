# Interactive Calculator (Calculator REPL)

This is an interactive calculator.

Run `./calculatorrepl` to start it.

At the moment it only really handles integers (so don't try dividing by a float).

## Description of Program

We define an equation recursively to be either (1) a single value, or (2) two nodes and an operator, where a node can be either a value or another equation. Then we take input line-by-line from the interactive session and apply a lexical parser to it. The lexical analysis returns an equation, which is then evaluated by eval.

## TODO

1. Extend functionality to include floating point numbers
2. ~~Make lexical analyser handle differing levels of whitespace~~
