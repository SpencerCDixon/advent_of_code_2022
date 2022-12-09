class Grid
  include Enumerable

  def initialize(values)
    @values = values
  end

  def each(&block)
    (0...width).each do |x|
      (0...height).each do |y|
        yield x, y
      end
    end
  end

  def width
    return 0 if values.empty?
    values[0].size
  end

  def height
    return 0 if values.empty?
    values.size
  end

  def at(x, y)
    values[y][x]
  end

  def is_edge?(x, y)
    return x == 0 || y == 0 || x == width - 1 || y == height - 1
  end

  def is_visible?(x, y)
    return true if is_edge?(x, y)
    tree_height = at(x, y)

    left = (0...x).all? {|x2| tree_height > at(x2, y) }
    right = (x + 1...width).all? {|x2| tree_height > at(x2, y) }
    up = (0...y).all? {|y2| tree_height > at(x, y2) }
    down = (y + 1...height).all? {|y2| tree_height > at(x, y2) }

    return left || right || up || down
  end

  def scenic_score(x, y)
    tree_height = at(x, y)

    left = 0
    (0...x).map{|x| x}.reverse.each do |x2| 
      left += 1

      if tree_height <= at(x2, y) 
        break
      end
    end

    right = 0
    (x + 1...width).each do |x2| 
      right += 1
      if tree_height <= at(x2, y) 
        break
      end
    end

    up = 0
    (0...y).map{|x| x}.reverse.each do |y2| 
      up += 1

      if tree_height <= at(x, y2) 
        break
      end
    end

    down = 0
    (y + 1...height).each do |y2|
      down += 1

      if tree_height <= at(x, y2) 
        break
      end
    end
    left * right * up * down
  end

  private

  def values
    @values
  end
end

values = []
File.readlines("input.txt").each do |line|
  values << line.chomp.split("").map(&:to_i)
end
grid = Grid.new(values)

# Part One
visible_trees = 0
grid.each do |x, y|
  if grid.is_visible?(x, y)
    visible_trees += 1
  end
end
puts visible_trees

# Part Two
highest = 0
grid.each do |x, y|
  score = grid.scenic_score(x, y)
  if score > highest
    highest = score
  end
end
puts highest