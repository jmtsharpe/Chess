
class Board
  attr_reader :board

  def initialize
    @board = generate_board
  end

  def [](pos)
    row, col = pos
    @board[row][col]
  end

  def []=(pos, mark)
    row, col = pos
    @board[row][col] = mark
  end

  def move(start, finish)
    piece = grab_peice(start)
  end

  def grab_peice(start)
    if self[start] = nil
      raise ChessError.new("There is no piece at this position")
    else
      self[start]
    end
  end

  def move_piece(piece, finish)
    if piece.valid_moves.include?(self[finish])
      piece.pos = [finish]
      self[start] = nil
      self[finish] = piece
    else
      raise ChessError.new("That is not a valid move for this piece")
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
        end
      end
    end
  end

  def pawn_row(coords)
    color = coords[0] == 1 ? :black : :white
    Pawn.new(coords, color)
  end

  def command_row(coords)
    color = coords[0] == 0 ? :black : :white
    case coords.last
    when 0 ; Rook.new(coords, color)
    when 1 ; Knight.new(coords, color)
    when 2 ; Bishop.new(coords, color)
    when 3 ; King.new(coords, color)
    when 4 ; Queen.new(coords, color)
    when 5 ; Bishop.new(coords, color)
    when 6 ; Knight.new(coords, color)
    when 7 ; Rook.new(coords, color)
    else raise "error"
    end
  end



end
