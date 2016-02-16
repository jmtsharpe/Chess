
class Player
  attr_reader :color

  def initialize(color, board)
    @color = color
    @display = Display.new(board)
    @board = board
  end

  def move
    result = nil
    until result
      @display.render
      result = @display.get_input
    end
    result
  end

  def take_turn
    piece = get_peice
    moveto = move
    @board.move(piece, moveto)
    @display.render
  end

  def get_peice
    piece = parse_selection(move)
  rescue ChessError => e
    puts e.message
    retry
  end

  def parse_selection(coords)
    p coords
    p @color
    if !@board[coords].is_a? Piece
      raise ChessError.new("No piece selected")
    elsif @board[coords].color != @color
      raise ChessError.new("Not a #{@color} piece.")
    else
      coords
    end
  end

end
