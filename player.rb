
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
      notifications
      result = @display.get_input
    end
    result
  end

  def notifications
    puts @color == :white ? "⚪ " : "⚫ "
    if @board.in_check?(@color)
      puts "#{@color} in check"
    end
  end

  def take_turn
    movefrom = make_selection
    moveto = move


    valid_move = false
    until valid_move
      unless @board.break_check?(@board[movefrom], moveto, @color)
        puts "You can't move into check"
        movefrom = make_selection
        moveto = move
        puts @board.break_check?(@board[movefrom], moveto, @color)
      else
        valid_move = true
      end
    end

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
