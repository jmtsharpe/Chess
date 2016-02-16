require "byebug"

class Piece
  attr_reader :pos, :moves, :color, :name

  def initialize(board, pos, color)
    @board = board
    @pos = pos
    @color = color
    @name = self.class.to_s
    @moves = []
  end

  DisplayPiece = {
    "King" => " ♚ ",
    "Queen" => " ♛ ",
    "Bishop" => " ♝ ",
    "Knight" => " ♞ ",
    "Rook" => " ♜ ",
    "Pawn" => " ♟ ",
    "Piece" => "bad"
  }

  def pos=(coords)
    @pos = coords
  end

  def inspect
    "#{@color} #{@name}: #{@pos}"
  end

  def to_s
    DisplayPiece[@name].colorize(@color)
  end

  def self.add_coords(coords1, coords2)
    [coords1[0] + coords2[0], coords1[1] + coords2[1]]
  end

  def get_moves
    raise ChessError.new("This is not a real Piece")
  end

end


module SlidingPiece

  Crossways = [ [0, 1], [1, 0], [0, -1], [-1, 0] ]
  Diagonals = [ [1, 1], [-1, -1], [1, -1], [-1, 1] ]

  def movement
    Local_movement.map do |move|
      tile = Piece.add_coords(@pos, move)
      while @board.in_bounds?(tile)
        @moves << tile if @board[tile].empty?

        if @board[tile].color == @color
          break
        else
          @moves << tile
          break
        end


    end
  end

  # def get_moves
  #   @valid_moves = []
  #
  #   DELTAS.each do |move|
  #     #pass = true
  #     step = Piece.add_coords(move, @pos)
  #
  #     while in_bounds? step
  #
  #
  #       if collision?(step) && @board[step].color != @color
  #         @valid_moves << step
  #         break
  #       elsif collision?(move)
  #         break
  #       else
  #         @valid_moves << step
  #         step = Piece.add_coords(move, step)
  #       end
  #     end
  #   end
  # end
end

module SteppingPiece

  # @localized movement is an array of the peices allowed moves
  # generalized to [0,0]
  def movement
    @moves = Local_movement.map do |move|
      Piece.add_coords(@pos, move)
    end
  end
end

class King < Piece
  include SteppingPiece

  Local_movement = [
    [0, 1],
    [1, 0],
    [0, -1],
    [-1, 0],
    [1, 1],
    [1, -1],
    [-1, 1],
    [-1, -1]
  ]

end

class Queen < Piece
  include SlidingPiece


end

class Bishop < Piece
  include SlidingPiece


end

class Knight < Piece
  include SteppingPiece

  Local_movement = [
    [1, 2],
    [2, 1],
    [-1, 2],
    [2, -1],
    [-2, 1],
    [1, -2],
    [-1, -2],
    [-2, -1]
  ]

end

class Rook < Piece
  include SlidingPiece


end

class Pawn < Piece
  include SteppingPiece


end
