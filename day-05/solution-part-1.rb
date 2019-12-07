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
      ins = read_instruction

      break if ins[:opcode] == '99'

      puts "ins: #{ins}"

      case ins[:opcode]
      when '01'
        n = add(ins[:param1_mode], ins[:param2_mode])
        self.pc = pc + n
      when '02'
        puts "multiplying!"
        n = multiply(ins[:param1_mode], ins[:param2_mode])
        self.pc = pc + n
      when '03'
        n = input
        self.pc = pc + n
      when '04'
        n = output(ins[:param1_mode])
        self.pc = pc + n
      end
    end
  end

  private

  def read_instruction
    instruction = state[pc]
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

    4
  end

  def multiply(mode_1, mode_2)
    first_operand = read_value(mode_1, pc + 1)
    second_operand = read_value(mode_2, pc + 2)
    dest = state[pc + 3]

    state[dest] = first_operand * second_operand

    4
  end

  def input
    dest = state[pc + 1]
    puts 'input:'
    num = gets.strip.to_i

    state[dest] = num
    2
  end

  def output(mode_1)
    value = read_value(mode_1, pc + 1)
    puts "Output: #{value}"
    2
  end
end

Machine.new(program).execute
