range = 153517..630395

def adjacent_digits(num)
  num.scan(/([0-9])(\1+)/).any? { |match| match[1].length == 1 }
end

def no_decreasing_digits(num)
  result = true
  num.chars.each_cons(2) do |a, b|
    result = false if b < a
  end

  result
end

suitable = []
range.each do |num|
  num_str = num.to_s
  suitable << num if adjacent_digits(num_str) && no_decreasing_digits(num_str)
end

puts suitable.length
