require_relative './machine'

input_file_path = File.join(File.dirname(__FILE__), 'input.txt')
program = File.open(input_file_path).read

phase_sequences = [0,1,2,3,4].permutation.to_a

outputs = []

phase_sequences.each do |phase_sequence|
  io = MachineIO.new(0)

  phase_sequence.each do |phase|
    input_signal = io.read
    io.write(phase)
    io.write(input_signal)
    Machine.new(program, io, io).execute
  end

  outputs << io.read
end

puts "maximum #{outputs.max}"
