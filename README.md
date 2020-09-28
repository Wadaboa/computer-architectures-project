# Computer Architectures project

This repository contains the implementation of three exercises, for the lab project of Computer Architectures class at UNIFI.

## Usage

In order to run the exercises, download a MIPS simulator, like [MARS](http://courses.missouristate.edu/kenvollmar/mars/) or [QtSpim](http://spimsimulator.sourceforge.net/)
and simply load them.

## Exercises

### 1. Strings analysis

Translates a given alphanumerical string into a sequence of '1', '2', '9' and '?' characters, by applying the following mapping:
* The substring "uno" becomes '1'
* The substring "due" becomes '2'
* The substring "nove" becomes '9'
* Everything else becomes '?'

For example, if the input string is "uno due ciao 33 tree tre uno Uno di eci" the output string will be "1 2 ? ? ? ? 1 ? ? ?".

### 2. Nested and recursive procedures

Let `G` and `F` be two procedures like the following:

```
Procedure G(n)
  begin
    b := 0
    for k := 0, 1, 2, ... , n do 
    begin
      b := b2 + u 
    end
    return b 
  end
```

```
Procedure F(n) 
  begin
    if n = 0 then return 1
    else return 2 * F(n − 1) + n 
  end
```

Let `n` be a natural number between 1 and 8. The software should output:
* The value returned by `G(n)`
* A trace of nested procedure calls and their intermediate results, for both `F` and `G`

### 3. Matrix operations

The software should support 5 different commands:
* _Matrix insertion_: Give the user the ability to insert a square matrix with dimensions between 1 and 4
* _Matrix sum_: Sum two identically-sized matrices
* _Matrix subtraction_: Subtract a matrix from another one with the same dimensions
* _Matrix product_: Apply row by column product of two compatible matrices
* _Exit_: Print an exit message and close the program

## Assignment & report

You can have a look at both the project [assignment](assignment.pdf) and the written [report](report.pdf), but beware that they have been written in the Italian language.
