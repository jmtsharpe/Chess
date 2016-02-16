require 'colorize'
require './cursorable.rb'
require './board.rb'
require './piece.rb'
require './display.rb'
require './player.rb'
require './chess_helper'



class ChessGame

  def initialize(chessboard)
    @chessboard = chessboard
    @players = [
      Player.new(:black, chessboard),
      Player.new(:white, chessboard)
    ]
  end

  def toggle_players
    @players.rotate!
  end

  def run
    until checkmate?
      @players[0].take_turn
      toggle_players
    end
    victory_conditions
  end

  def checkmate?
    # debugger
    @chessboard.checkmate?(@players[0].color)
  end

  def victory_conditions
    puts "CHECKMATE"
    puts "#{@players[0].color.to_s.capitalize} topples their King"
    puts "#{@players[1].color.to_s.capitalize} Wins!"
  end

end

# board = Board.new
# board.move([1,1], [2,1])
# board.move([2,1], [3,1])
# board.move([1,2], [2,2])
# board.move([6,3], [5,3])
# board.move([7,4], [3,0])
#
#
# game = ChessGame.new(board)
# game.run
