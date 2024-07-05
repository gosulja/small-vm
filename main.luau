type ValueType = "NUMBER"
type Value = { type: ValueType, value: number }

local Opcode = {
    HALT = 0x00,
    ADD = 0x01,
    CONST = 0x02,
}

function value(t: ValueType, v: number): Value
    return {
        type = t,
        value = v
    }
end

function run(program: {number}, constants: {Value})
    local pc = 1
    local sp = 1
    local stack: {Value} = {}

    local function push(value: Value)
        stack[sp] = value
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
        else
            error(string.format("Unknown opcode: %d", opcode))
        end
    end

    return nil
end

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