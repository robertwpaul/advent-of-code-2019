require_relative './machine'

input_file_path = File.join(File.dirname(__FILE__), 'input.txt')
program = File.open(input_file_path).read

phase_sequences = [0,1,2,3,4].permutation.to_a

outputs = []

phase_sequences.each do |phase_sequence|
  machine_output = MachineOutput.new

  phase_sequence.each do |phase|
    input_signal = machine_output.output.nil? ? 0 : machine_output.output

    machine_input = MachineInput.new([phase, input_signal])
    Machine.new(program, machine_input, machine_output).execute
  end

  outputs << machine_output.output
end

puts "maximum #{outputs.max}"
