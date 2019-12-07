class Machine
  attr_accessor :state, :pc

  PARAM_MODE_POSITION = 0
  PARAM_MODE_IMMEDIATE = 1

  def initialize(program, input_stream, output_stream)
    @state = program.split(',').map(&:to_i)
    @pc = 0
    @input_stream = input_stream
    @output_stream = output_stream
  end

  def execute
    loop do
      ins = read_instruction

      break if ins[:opcode] == '99'

      puts "ins: #{ins}"

      case ins[:opcode]
      when '01'
        add(ins[:param1_mode], ins[:param2_mode])
      when '02'
        multiply(ins[:param1_mode], ins[:param2_mode])
      when '03'
        input
      when '04'
        output(ins[:param1_mode])
      when '05'
        jump_if_true(ins[:param1_mode], ins[:param2_mode])
      when '06'
        jump_if_false(ins[:param1_mode], ins[:param2_mode])
      when '07'
        less_than(ins[:param1_mode], ins[:param2_mode])
      when '08'
        equals(ins[:param1_mode], ins[:param2_mode])
      else
        puts "Unrecognised opcode #{ins[:opcode]}"
        puts "pc: #{pc}"
        puts "state: #{state}"
        break
      end
    end
  end

  private

  def read_instruction
    instruction = state[pc]
    # puts "instruction #{instruction} at #{pc}; state: #{state}"
    padded = instruction.to_s.rjust(5, '0')

    param1_mode = padded[2] == '0' ? PARAM_MODE_POSITION : PARAM_MODE_IMMEDIATE
    param2_mode = padded[1] == '0' ? PARAM_MODE_POSITION : PARAM_MODE_IMMEDIATE
    param3_mode = padded[0] == '0' ? PARAM_MODE_POSITION : PARAM_MODE_IMMEDIATE

    return {
      opcode: padded.slice(3, 2),
      param1_mode: param1_mode,
      param2_mode: param2_mode,
      param3_mode: param3_mode
    }
  end

  def read_value(mode, position)
    if mode == PARAM_MODE_IMMEDIATE
      state[position]
    elsif PARAM_MODE_POSITION
      state[state[position]]
    end
  end

  def add(mode_1, mode_2)
    first_operand = read_value(mode_1, pc + 1)
    second_operand = read_value(mode_2, pc + 2)
    dest = state[pc + 3]

    state[dest] = first_operand + second_operand

    self.pc += 4
  end

  def multiply(mode_1, mode_2)
    first_operand = read_value(mode_1, pc + 1)
    second_operand = read_value(mode_2, pc + 2)
    dest = state[pc + 3]

    state[dest] = first_operand * second_operand

    self.pc += 4
  end

  def input
    dest = state[pc + 1]
    num = @input_stream.get_input
    state[dest] = num
    self.pc += 2
  end

  def output(mode_1)
    value = read_value(mode_1, pc + 1)
    @output_stream.write(value)
    self.pc += 2
  end

  def jump_if_true(mode_1, mode_2)
    param1 = read_value(mode_1, pc + 1)
    if param1.positive?
      self.pc = read_value(mode_2, pc + 2)
    else
      self.pc += 3
    end
  end

  def jump_if_false(mode_1, mode_2)
    param1 = read_value(mode_1, pc + 1)
    if param1.zero?
      self.pc = read_value(mode_2, pc + 2)
    else
      self.pc += 3
    end
  end

  def less_than(mode_1, mode_2)
    first_operand = read_value(mode_1, pc + 1)
    second_operand = read_value(mode_2, pc + 2)
    dest = state[pc + 3]

    state[dest] = first_operand < second_operand ? 1 : 0

    self.pc += 4
  end

  def equals(mode_1, mode_2)
    first_operand = read_value(mode_1, pc + 1)
    second_operand = read_value(mode_2, pc + 2)
    dest = state[pc + 3]

    state[dest] = first_operand == second_operand ? 1 : 0

    self.pc += 4
  end
end

class MachineInput
  def initialize(values)
    @values = values
  end

  def get_input
    @values.slice!(0)
  end
end

class MachineOutput
  attr_reader :output

  def initialize
    @output = nil
  end

  def write(value)
    @output = value
  end
end
