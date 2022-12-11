
class CPU
  attr_reader :x_reg, :cycle
  def initialize
    @x_reg = 1
    @cycle = 0
    @current_pixel = 0
    @current_instruction = nil
    @to_add = nil
  end

  def tick(instruction)
    @cycle += 1

    if !@to_add.nil?
      @x_reg += @to_add
      @to_add = nil
    end

    @current_pixel = (@cycle - 1) % 40
    if [x_reg - 1, x_reg, x_reg + 1].include?(@current_pixel)
      print "#"
    else
      print "."
    end
    if @cycle % 40 == 0
      print "\n"
    end

    if !@current_instruction.nil?
      @to_add = @current_instruction
      @current_instruction = nil
      true
    else
      if instruction.start_with?("noop")
        true
      else
        _, value = instruction.chomp.split(" ")
        to_add = value.to_i
        @current_instruction = to_add
        false
      end      
    end
  end

  def strength
    @x_reg * @cycle
  end
end

cpu = CPU.new
important_cycles = [20, 60, 100, 140, 180, 220]
strengths = []
File.readlines("input.txt").each do |line|
  loop do
    if important_cycles.include?(cpu.cycle)
      strengths << cpu.strength
    end

    break if cpu.tick(line)
  end
end
puts strengths.sum