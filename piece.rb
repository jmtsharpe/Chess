require "byebug"

class Piece
  attr_reader :pos, :valid_moves, :color, :name

  def initialize(board, pos, color)
    @board = board
    @pos = pos
    @color = color
    @name = self.class.to_s
  end

  DisplayPiece = {
    "King" => " ♚ "
    "Queen" => " ♛ "
    "Bishop" => " ♝ "
    "Knight" => " ♞ "
    "Rook" => " ♜ "
    "Pawn" => " ♟ "
    "Piece" => "bad"
  }

  def pos=(coords)
    @pos = coords
  end

  def inspect
    "#{@color} #{@name}: #{@pos}"
  end

  def to_s
    DisplayPiece[@name].colorize(@color))
  end

  def self.add_coords(coords1, coords2)
    [coords1[0] + coords2[0], coords1[1] + coords2[1]]
  end

  def get_moves
    raise ChessError.new("This piece has no moves")
  end

end


module SlidingPiece

  Crossways = [ [0, 1], [1, 0], [0, -1], [-1, 0] ]
  Diagonals = [ [1, 1], [-1, -1], [1, -1], [-1, 1] ]

  def get_moves
    @valid_moves = []

    DELTAS.each do |move|
      #pass = true
      step = Piece.add_coords(move, @pos)

      while in_bounds? step


        if collision?(step) && @board[step].color != @color
          @valid_moves << step
          break
        elsif collision?(move)
          break
        else
          @valid_moves << step
          step = Piece.add_coords(move, step)
        end
      end
    end
  end
end

module SteppingPiece

  def get_moves
    @valid_moves = DELTAS.map do |move|
      Piece.add_coords(move, @pos)
    end
    @valid_moves.select!{ |move| in_bounds?(move) }
  end

end

class King
  include SteppingPiece


end

class Queen
  include SlidingPiece


end

class Bishop
  include SlidingPiece


end

class Knight
  include SteppingPiece


end

class Rook
  include SlidingPiece


end

class Pawn
  include SteppingPiece


end
