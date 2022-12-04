SHAPE_BONUS = {
  'rock': 1, 
  'paper': 2,
  'scissors': 3,
}

def losing_value(value)
  case value
  when "rock"
    "scissors"
  when "paper"
    "rock"
  when "scissors"
    "paper"
  end
end

def winning_value(value)
  case value
  when "rock"
    "paper"
  when "paper"
    "scissors"
  when "scissors"
    "rock"
  end
end

def opponent_to_shape(str)
  case str
  when "A"
    "rock"
  when "B"
    "paper"
  when "C"
    "scissors"
  else
    raise ArgumentError("unknown shape type")
  end
end

def me_to_shape(opponent, str)
  case str
  when "X" # need to lose
    losing_value(opponent)
  when "Y" # need to draw
    opponent
  when "Z" # need to win
    winning_value(opponent)
  else
    raise ArgumentError("unknown shape type")
  end
end

def resolve_score(opponent, me)
  if opponent == me
    return 3
  end

  case me
  when "rock"
    if opponent == "scissors"
      return 6
    end
  when "paper"
    if opponent == "rock"
      return 6
    end
  when "scissors"
    if opponent == "paper"
      return 6
    end
  end

  0
end

total_score = 0
File.readlines('input.txt').each do |line|
  op_raw, me_raw = line.split(' ')

  op_move = opponent_to_shape(op_raw)
  me_move = me_to_shape(op_move, me_raw)

  total_score += resolve_score(op_move, me_move)
  total_score += SHAPE_BONUS[me_move.to_sym]
end
puts total_score