require "byebug"

class Piece
  attr_reader :pos, :color, :name
  attr_accessor :moves

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

  def get_bounds
    @moves.select! { |coord| @board.in_bounds?(coord) }
  end

end


module SlidingPiece

  CROSSWAYS = [ [0, 1], [1, 0], [0, -1], [-1, 0] ]
  DIAGONALS = [ [1, 1], [-1, -1], [1, -1], [-1, 1] ]

  def movement
    @moves = []
    get_local_movement.map do |move|
      tile = Piece.add_coords(@pos, move)
      while @board.in_bounds?(tile)
        if @board.empty?(tile)
          @moves << tile
        elsif @board[tile].color == @color
          break
        else
          @moves << tile
          break
        end
        tile = Piece.add_coords(tile, move)
      end
    end
    get_bounds
    @moves
  end

end

module SteppingPiece

  def movement
    @moves = []
    @moves = get_local_movement.map do |move|
      Piece.add_coords(@pos, move)
    end
    get_bounds
    @moves
  end
end

class King < Piece
  include SteppingPiece

  def get_local_movement
    [[0, 1],[1, 0],[0, -1],[-1, 0],[1, 1],[1, -1],[-1, 1],[-1, -1]]
  end

end

class Queen < Piece
  include SlidingPiece

  def get_local_movement
    SlidingPiece::CROSSWAYS + SlidingPiece::DIAGONALS
  end

end

class Bishop < Piece
  include SlidingPiece

  def get_local_movement
    SlidingPiece::DIAGONALS
  end

end

class Knight < Piece
  include SteppingPiece

  def get_local_movement
    [[1, 2],[2, 1],[-1, 2],[2, -1],[-2, 1],[1, -2],[-1, -2],[-2, -1]]
  end

end

class Rook < Piece
  include SlidingPiece

  def get_local_movement
    SlidingPiece::CROSSWAYS
  end

end

class Pawn < Piece

  def movement
    @moves = []
    @moves.push pawn_movement
    @moves.push *pawn_attack
    get_bounds
    @moves
  end

  def get_local_movement
    @color == :black ? [1,0] : [-1,0]
  end

  def pawn_movement
    move = Piece.add_coords(@pos, get_local_movement)
    return [] unless @board.empty?(move)
    move
  end

  def pawn_attack
    attack_pos = @colors == :black ? [[1,-1], [1,1]] : [[-1,-1], [-1,1]]
    attack_pos.map! do |move|
      Piece.add_coords(@pos, move)
    end
    attack_pos.reject do |coords|
      @board.empty?(coords)
    end
  end

end
