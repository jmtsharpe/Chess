
class Board
  attr_accessor :grid

  def initialize
    @grid = generate_board
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, mark)
    row, col = pos
    @grid[row][col] = mark
  end

  def move(start, finish)
    piece = grab_peice(start)
    move_piece(piece, finish)
  rescue ChessError => e
    puts e.message
  end

  def grab_peice(start)
    if self[start] == nil
      raise ChessError.new("There is no piece at this position")
    else
      self[start]
    end
  end

  def move_piece(piece, finish)
    if piece.valid_moves#.include?(self[finish])
      piece.pos = [finish]
      self[start] = nil
      self[finish] = piece
    else
      raise ChessError.new("That is not a valid move for this piece")
    end
  end

  def empty?(coords)

    self[coords].nil?

  end


  private

  def generate_board
    Array.new(8)  do |row|
      Array.new(8) do |col|
        if row == 0 || row == 7
          command_row([row,col])
        elsif row == 1 || row == 6
          pawn_row([row,col])
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
