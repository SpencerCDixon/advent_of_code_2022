require 'set'

input = File.read("input.txt")

end_idx = 13
beg_idx = 0
loop do
  result = input[beg_idx..end_idx]
  if Set.new(result.split("")).length == 14
    break
  end
  end_idx += 1
  beg_idx += 1
end
puts end_idx + 1