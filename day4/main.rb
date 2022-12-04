require 'pry'
require 'set'

cover = 0
File.readlines("input.txt").each do |line|
  elf1, elf2 = line.chomp.split(",")
    .map {|s| s.split("-") }
    .map {|s| s.map!(&:to_i) }
    .map {|i| Range.new(i[0], i[1]) }
  if elf1.cover?(elf2) || elf2.cover?(elf1)
    cover += 1
  end
end
puts "Part one: #{cover}"

overlap = 0
File.readlines("input.txt").each do |line|
  elf1, elf2 = line.chomp.split(",")
    .map {|s| s.split("-") }
    .map {|s| s.map!(&:to_i) }
    .map {|i| Set.new(Range.new(i[0], i[1])) }
  if elf1.intersection(elf2).size > 0
    overlap += 1
  end
end
puts "Part one: #{overlap}"