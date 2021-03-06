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
      Player.new(:white, chessboard),
      Player.new(:black, chessboard)
    ]
  end

  def toggle_players
    @players.rotate!
    @chessboard.color = @players.first
  end

  def run
    until checkmate?
      @players[0].take_turn
      toggle_players
    end
    victory_conditions
  end

  def checkmate?
    @chessboard.checkmate?(@players[0].color)
  end

  def victory_conditions
    puts "CHECKMATE"
    puts "#{@players[0].color.to_s.capitalize} topples their King"
    puts "#{@players[1].color.to_s.capitalize} Wins!"
    play_again?
  end

  def play_again?
    puts "Play again?"
    puts "Y/N"
    answer = gets.chomp

    case answer.downcase
    when "y"
      restart
    when "yes"
      restart
    when "n"
      puts "GoodBye!"
    when "no"
      puts "GoodBye!"
    else
      puts "Huh?"
      play_again?
    end
  end

  def restart
    board = Board.new
    game = ChessGame.new(board)
    game.run
  end

end

board = Board.new


game = ChessGame.new(board)
game.run
