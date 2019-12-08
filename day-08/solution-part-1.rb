input_file_path = File.join(File.dirname(__FILE__), 'input.txt')
image = File.open(input_file_path).read

pixels = image.chomp.chars.map(&:to_i)

width = 25
height = 6
image_resolution = width * height

num_layers = pixels.length / image_resolution

layers = []

(0...num_layers).each do |layer_num|
  layer = []
  (0...image_resolution).each do |x|
    pix = x + (layer_num * image_resolution)
    layer << pixels[pix]
  end

  layers << layer
end

fewest_zeros = layers.min do |a, b|
  a_zeros = a.count { |e| e == 0 }
  b_zeros = b.count { |e| e == 0 }
  a_zeros <=> b_zeros
end

number_ones = fewest_zeros.count { |e| e == 1 }
number_twos = fewest_zeros.count { |e| e == 2 }

puts "number ones #{number_ones}"
puts "number twos #{number_twos}"

puts "result: #{number_ones * number_twos}"
