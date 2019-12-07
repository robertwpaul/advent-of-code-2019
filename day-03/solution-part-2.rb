input_file_path = File.join(File.dirname(__FILE__), 'input.txt')
wire1, wire2 = File.readlines(input_file_path)

class Wire
  attr_accessor :visited, :x, :y

  def initialize
    @x = 0
    @y = 0
    @visited = []
  end

  def move_right(distance)
    (1..distance).each do
      self.x += 1
      visited << [x, y]
    end
  end

  def move_left(distance)
    (1..distance).each do
      self.x -= 1
      visited << [x, y]
    end
  end

  def move_up(distance)
    (1..distance).each do
      self.y -= 1
      visited << [x, y]
    end
  end

  def move_down(distance)
    (1..distance).each do
      self.y += 1
      visited << [x, y]
    end
  end
end

def trace_route(path)
  instructions = path.split(',')

  wire = Wire.new

  instructions.each do |i|
    direction, length = i.match(/([RLUD])([0-9]+)/).captures

    length = length.to_i

    case direction
    when 'R'
      wire.move_right(length)
    when 'L'
      wire.move_left(length)
    when 'U'
      wire.move_up(length)
    when 'D'
      wire.move_down(length)
    end
  end

  return wire.visited
end


wire1_route = trace_route(wire1)
wire2_route = trace_route(wire2)

crosses = wire1_route & wire2_route

lengths = crosses.map do |c|
  wire1_length = wire1_route.find_index(c) + 1
  wire2_length = wire2_route.find_index(c) + 1
  wire1_length + wire2_length
end

puts lengths.min
