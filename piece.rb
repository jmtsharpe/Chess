require "byebug"

class Piece
  attr_reader :pos, :color, :name
  attr_accessor :moves, :moved

  def initialize(board, pos, color)
    @board = board
    @pos = pos
    @color = color
    @name = self.class.to_s
    @moves = []
    @moved = false
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

  def redefine(board)
    @board = board
  end

end


module SlidingPiece

  CROSSWAYS = [ [0, 1], [1, 0], [0, -1], [-1, 0] ]
  DIAGONALS = [ [1, 1], [-1, -1], [1, -1], [-1, 1] ]

  def movement
    @moves = []
    get_local_movement.each do |move|
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
    @moves
  end

end

module SteppingPiece

  def movement
    @moves = []
    get_local_movement.each do |move|
      tile = Piece.add_coords(@pos, move)
      next unless @board.in_bounds?(tile)
      if @board.empty?(tile) || @board[tile].color != @color
        @moves << tile
      end
    end

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
    @moves.concat(pawn_movement)
    @moves.concat(pawn_attack)

    @moves
  end

  def get_local_movement
    if  @moved
      @color == :black ? [[1,0]] : [[-1,0]]
    else
      @color == :black ? [[1,0],[2,0]] : [[-1,0],[-2,0]]
    end
  end

  def pawn_movement
    moves = get_local_movement
    moves.map! { |move| Piece.add_coords(@pos, move) }
    moves.reject! do |coords|
      !@board.empty?(coords) || !@board.in_bounds?(coords)
    end
    moves
  end

  def pawn_attack
    attack_pos = @color == :black ? [[1,-1], [1,1]] : [[-1,-1], [-1,1]]
    attack_pos.map! { |move| Piece.add_coords(@pos, move) }
    attack_pos.reject! do |coords|
      if !@board.empty?(coords) && !@board[coords].nil?
        @board[coords].color == @color
      else
        @board.empty?(coords) || !@board.in_bounds?(coords)
      end
    end

    attack_pos
  end

end
