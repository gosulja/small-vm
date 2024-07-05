# Small VM

A minimalistic stack based virtual machine written in Luau, for the sake of typings.

# Explanation

Using the vm is quite simple, with the introduction of constants, stack pointer and program counter (instruction pointer) a simple program can be carried out.

For example:

Let's define our constants, 10 and 20
```lua
local constants = {
    value("NUMBER", 10),
    value("NUMBER", 20)
}
```

We should now construct our program which we want to run. We need to use the opcodes.

```lua
local program = {
    Opcode.CONST, 1,
    Opcode.CONST, 2,
    Opcode.ADD,
    Opcode.HALT
}
```

Now the `1` and `2` may look a bit confusing, that's because how arrays work in Luau, starting from 1.
They symbolise the indexes of the constants we want to push onto the stack, hence the opcode `CONST`. We then push `ADD` onto the stack, which adds the two top most values of the stack. `HALT` then halts the program and returns the top most value of the stack.

```lua
local constants = {
    value("NUMBER", 10),
    value("NUMBER", 20),
}

local program = {
    Opcode.CONST, 1,
    Opcode.CONST, 2,
    Opcode.ADD,
    Opcode.HALT
}

local result = run(program, constants)

print(result.value)
```

And now if you guessed correctly, the output will be `30` !!
