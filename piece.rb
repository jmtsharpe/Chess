

class Piece
  attr_accessor :pos
  
  def initialize(pos, color)
    @pos = pos
    @color = color
  end

end

class King < Piece

  def inspect
    "#{@color} King: #{@pos}"
  end

end

class Queen < Piece

  def inspect
    "#{@color} Queen: #{@pos}"
  end

end

class Bishop < Piece

  def inspect
    "#{@color} Bishop: #{@pos}"
  end

end

class Knight < Piece

  def inspect
    "#{@color} Knight: #{@pos}"
  end

end

class Rook < Piece

  def inspect
    "#{@color} Rook: #{@pos}"
  end

end

class Pawn < Piece

  def inspect
    "#{@color} Pawn: #{@pos}"
  end

end
