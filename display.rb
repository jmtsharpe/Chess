class Display

  def initialize(board)
    @chessboard = board
    @cursor = [4,4]
    @selected = nil
  end


  def board_colors(coords)
    pos = coords.inject(:+)
    if pos % 2 == 0
      @chessboard[coords].to_s.colorize(:background => :red)
    else
      @chessboard[coords].to_s.colorize(:background => :black)
    end
  end

  # def render
  #   @chessboard.grid.each do |row|
  #     row.each do |col|
  #       print board_colors(@chessboard[[row, col]])
  #     end
  #     puts
  #   end
  # end
  def render_chessboard
    @chessboard.grid.each do |row|
      p row
    end
  end
  # Reads keypresses from the user including 2 and 3 escape character sequences.
  def read_char
    STDIN.echo = false
    STDIN.raw!

    input = STDIN.getc.chr
    if input == "\e" then
      input << STDIN.read_nonblock(3) rescue nil
      input << STDIN.read_nonblock(2) rescue nil
    end
  ensure
    STDIN.echo = true
    STDIN.cooked!

    return input
  end

  # oringal case statement from:
  # http://www.alecjacobson.com/weblog/?p=75
  def show_single_key
    c = read_char

    case c
    when " "
      puts "SPACE"
    when "\e[A"
      puts "UP ARROW"
    when "\e[B"
      puts "DOWN ARROW"
    when "\e[C"
      puts "RIGHT ARROW"
    when "\e[D"
      puts "LEFT ARROW"
    when "\u0003"
      puts "CONTROL-C"
      exit 0
    end
  end


end
