require 'io/console'
require 'colorize'

require './board.rb'
require './piece.rb'
require './display.rb'

class ChessError < StandardError
end

game = Board.new
d = Display.new(game)
d.render_chessboard
