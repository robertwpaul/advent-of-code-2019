input_file_path = File.join(File.dirname(__FILE__), 'input.txt')
program = File.open(input_file_path).read

class Machine
  attr_accessor :state, :pc

  PARAM_MODE_POSITION = 0
  PARAM_MODE_IMMEDIATE = 1

  def initialize(program)
    @state = program.split(',').map(&:to_i)
    @pc = 0
  end

  def execute
    loop do
      opcode = instruction % 100

      break if opcode == 99

      case opcode
      when 1
        add
      when 2
        multiply
      when 3
        input
      when 4
        output
      when 5
        jump_if_true
      when 6
        jump_if_false
      when 7
        less_than
      when 8
        equals
      else
        raise "Unrecognised opcode: #{opcode}"
      end
    end
  end

  private

  def instruction
    state[pc]
  end

  def param_1_mode
    instruction % 1000 / 100
  end

  def param_2_mode
    instruction % 10000 / 1000
  end

  def param_3_mode
    instruction % 100000 / 10000
  end

  def read_value(mode, position)
    if mode == PARAM_MODE_IMMEDIATE
      state[position]
    elsif mode == PARAM_MODE_POSITION
      state[state[position]]
    end
  end

  def write_value(value, position)
    state[state[position]] = value
  end

  def add
    op1 = read_value(param_1_mode, pc + 1)
    op2 = read_value(param_2_mode, pc + 2)

    result = op1 + op2

    write_value(result, pc + 3)

    self.pc += 4
  end

  def multiply
    op1 = read_value(param_1_mode, pc + 1)
    op2 = read_value(param_2_mode, pc + 2)

    result = op1 * op2

    write_value(result, pc + 3)

    self.pc += 4
  end

  def input
    puts "Input: "
    num = gets.strip.to_i
    write_value(num, pc + 1)
    self.pc += 2
  end

  def output
    value = read_value(param_1_mode, pc + 1)
    puts "Value: #{value}"
    self.pc += 2
  end

  def jump_if_true
    param1 = read_value(param_1_mode, pc + 1)

    if param1.positive?
      self.pc = read_value(param_2_mode, pc + 2)
    else
      self.pc += 3
    end
  end

  def jump_if_false
    param1 = read_value(param_1_mode, pc + 1)

    if param1.zero?
      self.pc = read_value(param_2_mode, pc + 2)
    else
      self.pc += 3
    end
  end

  def less_than
    param1 = read_value(param_1_mode, pc + 1)
    param2 = read_value(param_2_mode, pc + 2)

    if param1 < param2
      write_value(1, pc + 3)
    else
      write_value(0, pc + 3)
    end

    self.pc += 4
  end

  def equals
    param1 = read_value(param_1_mode, pc + 1)
    param2 = read_value(param_2_mode, pc + 2)

    if param1 == param2
      write_value(1, pc + 3)
    else
      write_value(0, pc + 3)
    end

    self.pc += 4
  end
end

Machine.new(program).execute
