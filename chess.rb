require 'colorize'
require './cursorable.rb'
require './board.rb'
require './piece.rb'
require './display.rb'
require './player.rb'

class ChessError < StandardError
end

chessboard = Board.new
player = Player.new(chessboard)
player.move
