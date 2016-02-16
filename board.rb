
class Board
  attr_accessor :rows
  BLANK_SPACE = "   "
  def initialize
    @rows = generate_board
    #check_all_moves
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
    if piece#.valid_moves.include?(moveto)
      self[piece.pos] = BLANK_SPACE
      piece.pos = moveto
      self[moveto] = piece
      #check_all_moves
    else
      raise ChessError.new("That is not a valid move for this piece")
    end
  end

  def in_bounds?(coords)
    coords.all? do |coord|
      (0..7).cover? coord
    end
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
