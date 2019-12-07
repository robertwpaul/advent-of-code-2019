input_file_path = File.join(File.dirname(__FILE__), 'input.txt')

def calculate_fuel(mass)
  fuel = (mass / 3).floor - 2
  return 0 if fuel <= 0
  fuel + calculate_fuel(fuel)
end

fuel = File.open(input_file_path).sum do |mass|
  calculate_fuel(mass.to_i)
end

puts fuel
