require 'pry'

# Parse input sections
crates_str = ""
moves = ""
in_starting_crates = true
File.readlines("input.txt").each do |line|
  if line.chomp.empty?
    in_starting_crates = false
    next
  end
  in_starting_crates ? crates_str << line : moves << line
end

# Build starting stacks
starting_crates = Array.new()
9.times { starting_crates << [] }

crates_str.split("\n").reverse.drop(1).each do |row|
  row.chars.each_slice(4).each_with_index do |column, idx|
    if !column[1].strip.empty?
      starting_crates[idx] << column[1]
    end
  end
end

def parse_move(str)
    _, move, _, from, _, to = str.split(" ")
    [move.to_i, from.to_i, to.to_i]
end

# Apply moves part 1
moves.split("\n").each do |line|
  move, from, to = parse_move(line)

  move.times do 
    popped = starting_crates[from - 1].pop
    starting_crates[to - 1].push(popped)
  end
end

# Apply moves part 2
moves.split("\n").each do |line|
  move, from, to = parse_move(line)
  column = starting_crates[from - 1]
  sliced = column.slice!(column.size - move..)
  starting_crates[to - 1].push(*sliced)
end

final = ""
starting_crates.each do |column|
  final << column.last
end
puts final
