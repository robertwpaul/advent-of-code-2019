require_relative './machine'

input_file_path = File.join(File.dirname(__FILE__), 'input.txt')
program = File.open(input_file_path).read

phase_sequences = [5,6,7,8,9].permutation.to_a

outputs = []

phase_sequences.each do |sequence|
  a_input = MachineIO.new(sequence[0], 0)
  b_input = MachineIO.new(sequence[1])
  c_input = MachineIO.new(sequence[2])
  d_input = MachineIO.new(sequence[3])
  e_input = MachineIO.new(sequence[4])

  amps = [
    Thread.new { Machine.new(program, a_input, b_input).execute },
    Thread.new { Machine.new(program, b_input, c_input).execute },
    Thread.new { Machine.new(program, c_input, d_input).execute },
    Thread.new { Machine.new(program, d_input, e_input).execute },
    Thread.new { Machine.new(program, e_input, a_input).execute }
  ]

  amps.each { |a| a.join }

  outputs << a_input.read
end

puts "outputs length: #{outputs.length}"
puts "max output: #{outputs.max}"
