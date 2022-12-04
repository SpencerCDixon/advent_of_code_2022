require 'set'
require 'pry'

def priority_value(str)
  ascii_offset = str.upcase == str ? 38 : 96
  str.ord - ascii_offset
end

# Part One
priority = 0
File.readlines('input.txt').each do |line|
  left, right = line.chomp.split("").each_slice(line.size / 2.0).to_a
  intersection = Set.new(left).intersection(Set.new(right)).to_a
  raise "unexpected intersection size" if intersection.size != 1
  priority += priority_value(intersection.first)
end
puts "Part one: #{priority}"

# Part Two
priority = 0
group = []
File.readlines('input.txt').each do |line|
  if group.size < 3
    group << line.chomp.split("")
  end

  if group.size == 3
    intersection = group[0] & group[1] & group[2]
    raise "unexpected intersection size" if intersection.size != 1
    priority += priority_value(intersection.first)
    group = []
  end
end
puts "Part two: #{priority}"
