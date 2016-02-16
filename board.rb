require "byebug"

class Board
  attr_accessor :rows
  BLANK_SPACE = "   "

  def initialize(rows = nil)
    @rows = rows ? rows : generate_board
    #check_all_moves
  end

  def inspect
    @rows.each do |row|
      p row.map{|el| el == BLANK_SPACE ? "                " : el}
    end
    nil
  end

  def check_all_moves
    @rows.flatten.each do |tile|
      tile.get_moves if tile.is_a?(Piece)
    end
  end

  def [](pos)
    row, col = pos
    @rows[row][col]
  end

  def []=(pos, mark)
    row, col = pos
    @rows[row][col] = mark
  end

  def move(movefrom, moveto)
    piece = self[movefrom]
    piece.movement
    if piece.moves.include?(moveto)
      direct_move(piece, moveto)
    else
      raise ChessError.new("That is not a valid move for this piece")
    end
  end

  def direct_move(piece, moveto)
    self[piece.pos] = BLANK_SPACE
    piece.pos = moveto
    self[moveto] = piece
  end

  def in_bounds?(coords)
    coords.all? do |coord|
      (0..7).cover? coord
    end
  end

  def empty?(coords)
    self[coords] == BLANK_SPACE
  end

  def in_check?(color)
    opp_color = color == :white ? :black : :white
    throne = find_king(color).pos
    select_pieces(opp_color).each do |piece|
      debugger if piece.is_a? Queen
      return true if piece.movement.include?(throne)
    end
    false
  end

  def checkmate?(color)
    return false unless in_check?(color)
    select_pieces(color).each do |piece|
      piece.movement.each do |move|
        return false if break_check?(piece, move, color)
      end
    end
    true
  end

  def break_check?(piece, moveto, color)
    dupped = dup_board
    dupped.direct_move(piece, moveto)
    good_move = !dupped.in_check?(color)
    good_move
  end

  def dup_board
    dupped = Board.new(@rows.deep_dup)
    dupped.select_pieces(:white).each{ |piece| piece.redefine(dupped) }
    dupped.select_pieces(:black).each{ |piece| piece.redefine(dupped) }
    dupped
  end

  def select_pieces(color)
    @rows.flatten.select do |tile|
      tile.is_a?(Piece) && tile.color == color
    end
  end

  def find_king(color)
    @rows.flatten.select do |tile|
      tile.is_a?(King) && tile.color == color
    end.pop
  end

  private

  def generate_board
    Array.new(8)  do |row|
      Array.new(8) do |col|
        if row == 0 || row == 7
          command_row([row,col])
        elsif row == 1 || row == 6
          pawn_row([row,col])
        else
          BLANK_SPACE
        end
      end
    end
  end

  def pawn_row(coords)
    color = coords[0] == 1 ? :black : :white
    Pawn.new(self, coords, color)
  end

  def command_row(coords)
    color = coords[0] == 0 ? :black : :white
    case coords.last
    when 0 ; Rook.new(self, coords, color)
    when 1 ; Knight.new(self, coords, color)
    when 2 ; Bishop.new(self, coords, color)
    when 3 ; King.new(self, coords, color)
    when 4 ; Queen.new(self, coords, color)
    when 5 ; Bishop.new(self, coords, color)
    when 6 ; Knight.new(self, coords, color)
    when 7 ; Rook.new(self, coords, color)
    else raise "error"
    end
  end



end
