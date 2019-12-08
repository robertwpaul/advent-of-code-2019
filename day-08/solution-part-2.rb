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

output_image = []

(0...image_resolution).each do |pixel|
  visible_layer = layers.find do |layer|
    layer[pixel] != 2
  end
  output_image[pixel] = visible_layer[pixel]
end

formatted_output = ''

(0...height).each do |y|
  (0...width).each do |x|
    formatted_output += output_image[x + y * width] == 1 ? '*' : ' '
  end
  formatted_output << "\n"
end

puts "#{formatted_output}"

