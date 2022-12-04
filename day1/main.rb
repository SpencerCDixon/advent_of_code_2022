require 'pry'

elves = {}
current = 0

File.readlines('input.txt').each_with_index do |line, idx|
  if line == "\n"
    elves[idx] = current
    current = 0
  else
    current += line.to_i
  end
end
puts elves.values.sort.last(3).sum