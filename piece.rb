

class Piece
  attr_reader :pos, :valid_moves
  DELTAS = [-1,-1,0,1,1]permutation(2).to_a.uniq

  def initialize(board, pos, color)
    @board = board
    @pos = pos
    @color = color
    @name = self.class.to_s
    @valid_moves = []
  end

  def check_moves
    #THROW ERROR
  end

  def pos=(coords)
    @pos = coords
    valid_moves
    # cache valid moves
  end

  def inspect
    "#{@color} #{@name}: #{@pos}"
  end

  def to_s
    "#{name[0]}#{name[-1]}"
  end

  def self.add_coords(coords1, coords2)
    [coords1[0] + coords2[0], coords1[1] + coords2[1]]
  end

  def collision?(coords)
    !@board[coords].empty?
  end

  def in_bounds?(coords)
    coords.all? do |coord|
      (0..7).cover? coord
    end
  end

end

class SlidingPiece < Piece


  def get_slides
    @valid_moves = []

    DELTAS.each do |move|
      #pass = true
      step = Piece.add_coords(move, @pos)

      while in_bounds? step
        if collision?(step) && @board[step].color != @color
          @valid_moves << step
          break
        elsif collision?(move)
          break
        else
          @valid_moves << step
          step = Piece.add_coords(move, step)
        end
      end

    end

  end

end

class SteppingPiece < Piece

  def get_steps
    @valid_moves = DELTAS.map do |move|
      Piece.add_coords(move, @pos)
    end
    @valid_moves.select!(&:in_bounds?)
  end

end

class King < SteppingPiece



end

class Queen < SlidingPiece



end

class Bishop < SlidingPiece



end

class Knight < SteppingPiece



end

class Rook < SlidingPiece



end

class Pawn < SteppingPiece



end
