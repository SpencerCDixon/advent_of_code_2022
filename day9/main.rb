require 'set'

class Point
  attr_accessor :x, :y
  def initialize(x, y)
    @x = x
    @y = y
  end

  def ==(other)
    self.class == other.class &&
      @x == other.x &&
      @y == other.y  
  end

  def to_s
    "#{x},#{y}"
  end
end

class Node
  attr_reader :next_piece, :movements, :id
  attr_accessor :location

  def initialize(starting_location, next_piece, id)
    @location = starting_location
    @next_piece = next_piece
    @id = id
    @movements = []
    @movements << starting_location
  end

  def reconcile()
    if !surrounds?(location, next_piece.location)
      snap_to_next()
    end
  end

  def surrounds?(p1, p2)
    Point.new(p1.x - 1, p1.y - 1) == p2 ||
    Point.new(p1.x - 1, p1.y) == p2 ||
    Point.new(p1.x - 1, p1.y + 1) == p2 ||
    Point.new(p1.x, p1.y + 1) == p2 ||
    Point.new(p1.x, p1.y - 1) == p2 ||
    Point.new(p1.x + 1, p1.y - 1) == p2 ||
    Point.new(p1.x + 1, p1.y) == p2 ||
    Point.new(p1.x + 1, p1.y + 1) == p2 ||
    p1 == p2
  end

  def adjacent?(p1, p2)
    x_diff = (p1.x - p2.x).abs
    y_diff = (p1.y - p2.y).abs
    x_diff <= 1 && y_diff <= 1
  end

  def snap_to_next()
    next_point = Point.new(location.x, location.y)

    next_x = next_piece.location.x
    next_y = next_piece.location.y

    loop do
      if adjacent?(next_point, next_piece.location)
        break
      end
      if next_point.x != next_x
        if next_point.x < next_x
          next_point.x += 1
        else
          next_point.x -= 1
        end
      end
      if next_point.y != next_y
        if next_point.y < next_y
          next_point.y += 1
        else
          next_point.y -= 1
        end
      end
    end

    snap_to(next_point)
  end

  def snap_to(point)
    @location = point
    @movements << point
  end
end

class Simulation
  attr_reader :head, :tail_nodes

  def initialize
    @head = Node.new(Point.new(0, 0), nil, "H")
    @tail_nodes = []

    current = @head
    9.times do |n|
      new_node = Node.new(Point.new(0,0), current, "#{n + 1}")
      @tail_nodes << new_node
      current = new_node
    end
  end

  def move(direction, amount)
    raise "expect amount to be an integer" unless amount.is_a? Integer
    amount.times do
      # pretty_print
      move_once(direction)
    end
  end

  def move_once(direction)
    case direction
    when "R"
      @head.location = Point.new(head.location.x + 1, head.location.y)
    when "D"
      @head.location = Point.new(head.location.x, head.location.y - 1)
    when "U"
      @head.location = Point.new(head.location.x, head.location.y + 1)
    when "L"
      @head.location = Point.new(head.location.x - 1, head.location.y)
    else
      raise "no way to handle direction: #{direction}"
    end

    @tail_nodes.each do |node|
      node.reconcile()
    end
  end

  def pretty_print
    width = [head.location.x, tail_nodes.last.location.x, 10].max
    height = [head.location.y, tail_nodes.last.location.y, 10].max

    (0..height).each do |y|
      (0..width).each do |x|
        found = false
        nodes_to_check = [head].concat(tail_nodes)
        nodes_to_check.each do |n|
          if n.location == Point.new(x, y)
            found = true
            print n.id
            break
          end
        end

        if !found
          print "."
        end
      end
      print "\n"
    end
  end
end

sim = Simulation.new

File.readlines("input.txt").each do |line|
  direction, amount = line.chomp.split(" ")
  sim.move(direction, amount.to_i)
end

puts sim.tail_nodes.last.movements.map(&:to_s).uniq.size