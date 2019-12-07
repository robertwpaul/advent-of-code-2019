input_file_path = File.join(File.dirname(__FILE__), 'input.txt')

fuel = File.open(input_file_path).sum do |mass|
  (mass.to_i / 3).floor - 2
end

puts fuel
