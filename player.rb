
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
      print @color == :white ? "⚪ " : "⚫ "
      puts "#{@color} in check? #{@board.in_check?(@color)}"
      result = @display.get_input
    end
    result
  end

  def take_turn
    movefrom = make_selection
    moveto = move
    @board.move(movefrom, moveto)
    @display.render
  rescue ChessError => e
    puts e.message
    puts "Move cancelled. Select again."
    retry
  end

  def make_selection
    piece = parse_selection(move)
  rescue ChessError => e
    puts e.message
    retry
  end

  def parse_selection(coords)
    if !@board[coords].is_a? Piece
      raise ChessError.new("There is no piece at this position")
    elsif @board[coords].color != @color
      raise ChessError.new("Not a #{@color} piece.")
    else
      coords
    end
  end

end
