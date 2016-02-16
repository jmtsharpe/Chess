require 'colorize'
require './cursorable.rb'
require './board.rb'
require './piece.rb'
require './display.rb'
require './player.rb'
require './chess_helper'



class ChessGame

  def initialize(chessboard)
    @chessboard = Board.new
    @players = [
      Player.new(:white, chessboard),
      Player.new(:black, chessboard)
    ]
  end

  def toggle_players
    @players.rotate!
  end

  def run
    turns = 10
    until turns == 0
      turns -= 1
      @players[0].take_turn
      toggle_players
    end
  end

end



game = ChessGame.new(Board.new)
game.run
