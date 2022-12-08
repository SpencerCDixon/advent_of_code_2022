require 'pathname'

class DirNode
  attr_accessor :parent, :path, :children

  def initialize(parent, path)
    @parent = parent
    @path = path
    @children = []
  end

  def add_child(node)
    @children << node
  end

  def find_child(path)
    children.each do |child|
      return child if child.path.chomp == path.chomp
    end
    return nil
  end

  def root
    return self if parent.nil?
    tmp = parent
    loop do
      return tmp if tmp.parent.nil?
      tmp = tmp.parent
    end
  end

  def walk(&block)
    yield self
    children.each {|c| c.walk(&block) }
  end

  def pretty_print(level = 0)
    level.times {|_| print " " }
    puts "- #{path.chomp} (dir)"
    next_level = level + 1
    children.each do |child|
      child.pretty_print(next_level)
    end
    nil
  end

  def size
    0
  end

  def is_dir?
    true
  end

  def abs_path
    if parent.nil?
      return path
    end

    pieces = []
    pieces << path
    tmp = parent
    until tmp.nil?
      pieces << tmp.path
      tmp = tmp.parent
    end

    pieces.reverse.reduce(Pathname.new('')) { |p, a| p.join(a) }.to_s
  end
end

class FileNode
  attr_accessor :size, :path, :parent

  def initialize(size, path, parent)
    @size = size
    @path = path
    @parent = parent
  end

  def pretty_print(level = 0)
    level.times {|_| print " " }
    puts "- #{path.chomp} (file, size=#{size})"
  end

  def children
    []
  end

  def walk
    yield self
  end

  def is_dir?
    false
  end

  def abs_path
    parent.abs_path + "/" + path
  end
end

cwd = nil
in_ls = false
File.readlines("input.txt").each do |line|
  if line.start_with?("$")
    command = line[2..3]

    if command == "ls"
      in_ls = true
    else
      in_ls = false
    end

    if command == "cd"
      path = line[5..].chomp
   
      if cwd.nil? # Create our root node
        cwd = DirNode.new(nil, path)
      elsif path == ".." # Go up to the parent, should probably error check here...
        cwd = cwd.parent
      elsif node = cwd.find_child(path)
        cwd = node
      else
        raise "something went wrong"
      end
    end
  else
    if in_ls
      if line.start_with?("dir")
        path = line[4..].chomp
        dir_node = DirNode.new(cwd, path)
        cwd.add_child(dir_node)
      else
        size, filename = line.split(" ")
        node = FileNode.new(size.to_i, filename, cwd)
        cwd.add_child(node)
      end
    end
  end 
end

root_node = cwd.root
puts root_node.pretty_print

def calculate_dir_sizes(node, totals = [])
  total = 0
  node.walk do |child|
    if child.is_dir? && node != child
      subdir_total = calculate_dir_sizes(child, totals)
      totals << { abs_path: child.abs_path, path: child.path, total: subdir_total }    
    else
      total += child.size
    end
  end
  totals << { abs_path: node.abs_path, path: node.path, total: total }
  total
end

totals = []
calculate_dir_sizes(root_node, totals)

# Part One
sum = 0
totals.uniq.each do |dir|
  if dir[:total] < 100000
    sum += dir[:total]
  end
end
puts sum

# Part Two
TOTAL_DISK = 70000000
REQUIRED_SPACE = 30000000
USED_SPACE = totals.find {|dir| dir[:path] == "/"}[:total]
puts "Used space is: #{USED_SPACE}"

possible_dir_to_delete = []
totals.each do |dir|
  if TOTAL_DISK - USED_SPACE + dir[:total] > REQUIRED_SPACE
    possible_dir_to_delete << dir
  end
end
puts possible_dir_to_delete.sort_by { |dir| dir[:total] }.first