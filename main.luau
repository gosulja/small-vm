type ValueType = "NUMBER" | "STRING"
type Value = { type: ValueType, value: any }

local Opcode = {
    HALT = 0x00,
    CONST = 0x01,
    ADD = 0x02,
    SUB = 0x03,
    MUL = 0x04,
    DIV = 0x05,
    CONCAT = 0x06,
}

function value(t: ValueType, v: any): Value
    return {
        type = t,
        value = v
    }
end

function run(program: {number}, constants: {Value})
    local pc = 1
    local sp = 1
    local stack: {Value} = {}

    local function push(v: Value)
        stack[sp] = v
        sp += 1
    end

    local function pop(): Value
        sp -= 1
        return stack[sp]
    end

    local function read_byte(): number
        local byte = program[pc]
        pc += 1
        return byte
    end

    local function get_const(): Value
        return constants[read_byte()]
    end

    while true do 
        local opcode = read_byte()
        if opcode == Opcode.HALT then
            return pop()
        elseif opcode == Opcode.CONST then
            push(get_const())
        elseif opcode == Opcode.ADD then
            local right = pop().value
            local left = pop().value
            push(value("NUMBER", left + right))
        elseif opcode == Opcode.SUB then
            local right = pop().value
            local left = pop().value
            push(value("NUMBER", left - right))
        elseif opcode == Opcode.MUL then
            local right = pop().value
            local left = pop().value
            push(value("NUMBER", left * right))
        elseif opcode == Opcode.DIV then
            local right = pop().value
            local left = pop().value
            push(value("NUMBER", left / right))
        elseif opcode == Opcode.CONCAT then
            local left = pop().value
            local right = pop().value
            push(value("STRING", left .. right))
        else
            error(string.format("Unknown opcode: 0x%d", opcode))
        end
    end

    return nil
end

local constants = {
    value("STRING", "world!"),
    value("STRING", "hello, "),
}

local program = {
    Opcode.CONST, 1,
    Opcode.CONST, 2,
    Opcode.CONCAT,
    Opcode.HALT
}

local result = run(program, constants)

print(result.value)