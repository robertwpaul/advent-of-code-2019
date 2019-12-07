require_relative './machine'

input_file_path = File.join(File.dirname(__FILE__), 'input.txt')
program = File.open(input_file_path).read

phase_sequences = [5,6,7,8,9].permutation.to_a

outputs = []

class ThreadableIO
  def initialize(*initial_values)
    @queue = Queue.new
    initial_values.each { |v| @queue.push(v) }
  end

  def get_input
    @queue.pop
  end

  def write(value)
    @queue.push(value)
  end
end

phase_sequences.each do |sequence|
  a_input = ThreadableIO.new(sequence[0], 0)
  b_input = ThreadableIO.new(sequence[1])
  c_input = ThreadableIO.new(sequence[2])
  d_input = ThreadableIO.new(sequence[3])
  e_input = ThreadableIO.new(sequence[4])

  amps = [
    Thread.new { Machine.new(program, a_input, b_input).execute },
    Thread.new { Machine.new(program, b_input, c_input).execute },
    Thread.new { Machine.new(program, c_input, d_input).execute },
    Thread.new { Machine.new(program, d_input, e_input).execute },
    Thread.new { Machine.new(program, e_input, a_input).execute }
  ]

  amps.each { |a| a.join }

  outputs << a_input.get_input
end

puts "outputs length: #{outputs.length}"
puts "max output: #{outputs.max}"
