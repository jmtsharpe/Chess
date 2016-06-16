require "byebug"

class Board
  attr_accessor :rows, :piece, :color
  BLANK_SPACE = "   "

  def initialize(rows = nil)
    @rows = rows ? rows : generate_board
    @piece = false
    @color = nil
  end

  def inspect
    @rows.each do |row|
      p row.map{|el| el == BLANK_SPACE ? "                " : el}
    end
  end

  def previous(moved, taken)
    
  end



  def check_all_moves
    @rows.flatten.each do |tile|
      tile.get_moves if tile.is_a?(Piece)
    end
  end

  def [](pos)
    row, col = pos
    @rows[row][col]
  end

  def []=(pos, mark)
    row, col = pos
    @rows[row][col] = mark
  end

# ||||||
# pick up piece logic

def pick(coords)
  if empty?(coords) || !same_color?(coords)
    return
  else
    @piece = self[coords]
  end

end

# |||||
# same color checks

def same_color(coords)
  self[coords].color == @color
end



# ||||||

  def move(movefrom, moveto)
    piece = self[movefrom]
    piece.movement
    if piece.moves.include?(moveto)
      direct_move(piece, moveto)
    else
      raise ChessError.new("That is not a valid move for this piece")
    end
  end

  def direct_move(piece, moveto)
    self[piece.pos] = BLANK_SPACE
    piece.pos = moveto
    self[moveto] = piece
    piece.moved = true
  end

  def in_bounds?(coords)
    coords.all? do |coord|
      (0..7).cover? coord
    end
  end

  def empty?(coords)
    self[coords] == BLANK_SPACE
  end

  def in_check?(color)
    opp_color = color == :white ? :black : :white

    throne = find_king(color)
    throne = throne.pos


    if check_knights(opp_color, throne)
      return true
    elsif check_bishops_and_royal(opp_color, throne)
      return true
    elsif check_rooks_and_royal(opp_color, throne)
      return true
    elsif check_pawns(opp_color, throne)
      return true
    else
      return false
    end

  end

  def check_knights(opp_color, throne)
    spots = [[1,2], [-1,2], [1,-2],[-1,-2],[2,1],[2,-1],[-2,1],[-2,-1]]

    spots.each do |spot|
      pos = throne.zip(spot).map {|a| a.inject(:+)}
      next if pos[0] > 7 || pos[0] < 0
      next if pos[1] > 7 || pos[1] < 0

      curr_spot = self[pos]
      if curr_spot.is_a?(Knight)
        if curr_spot.color == opp_color
          return true
        end
      end
    end

    return false

  end

  def check_bishops_and_royal(opp_color, throne)
    dirs = [[1,1],[1,-1],[-1,1],[-1,-1]]

    dirs.each do |dir|
      blocked = false
      pos = throne.zip(dir).map {|a| a.inject(:+)}
      next if pos[0] > 7 || pos[0] < 0
      next if pos[1] > 7 || pos[1] < 0
      curr_spot = self[throne.zip(dir).map {|a| a.inject(:+)}]
      while !blocked
        if curr_spot.is_a?(Piece)
          if curr_spot.is_a?(Bishop) || curr_spot.is_a?(Queen)
            if curr_spot.color == opp_color
              return true
            end
          else
            blocked = true
          end
        end
        pos = pos.zip(dir).map {|a| a.inject(:+)}
        break if pos[0] > 7 || pos[0] < 0
        break if pos[1] > 7 || pos[1] < 0
        curr_spot = self[pos]
      end
    end
    return false
  end

  def check_rooks_and_royal(opp_color, throne)
    dirs = [[1,0],[0,1],[-1,0],[0,-1]]

    dirs.each do |dir|
      blocked = false
      pos = throne.zip(dir).map {|a| a.inject(:+)}
      next if pos[0] > 7 || pos[0] < 0
      next if pos[1] > 7 || pos[1] < 0
      curr_spot = self[pos]
      return true if curr_spot.is_a?(King)
      while !blocked
        if curr_spot.is_a?(Piece)
          if curr_spot.is_a?(Rook) || curr_spot.is_a?(Queen)
            if curr_spot.color == opp_color
              return true
            end
          else
            blocked = true
          end
        end
        pos = pos.zip(dir).map {|a| a.inject(:+)}
        break if pos[0] > 7 || pos[0] < 0
        break if pos[1] > 7 || pos[1] < 0
        curr_spot = self[pos]

      end
    end
    return false
  end

  def check_pawns(opp_color, throne)
    color = opp_color == :white ? :black : :white

    if color == :white
      danger = [[-1,-1],[-1,1]]
    else
      danger = [[1,-1],[1,1]]
    end
    i = 0
    while i < 2
      curr_spot = self[throne.zip(danger[i]).map {|a| a.inject(:+)}]
      if curr_spot.is_a?(Pawn)
        if curr_spot.color == opp_color
          return true
        end
      end
      i += 1
    end

    return false
  end



  def checkmate?(color)
    return false unless in_check?(color)
    select_pieces(color).each do |piece|
      piece.movement.each do |move|
        return false if break_check?(piece, move, color)
      end
    end
    true
    # false
  end

  def break_check?(piece, moveto, color)
    dupped = dup_board
    og_spot = piece.pos
    dupped.direct_move(piece, moveto)
    good_move = !dupped.in_check?(color)
    dupped.direct_move(piece, og_spot)
    good_move
  end

  def dup_board
    dupped = Board.new(@rows.deep_dup)
    dupped.select_pieces(:white).each{ |piece| piece.redefine(dupped) }
    dupped.select_pieces(:black).each{ |piece| piece.redefine(dupped) }
    dupped
  end

  def select_pieces(color)
    @rows.flatten.select do |tile|
      tile.is_a?(Piece) && tile.color == color
    end
  end

  def find_king(color)
    king = @rows.flatten.select do |tile|
      tile.is_a?(King) && tile.color == color
    end
    king.first
  end

  private

  def generate_board
    Array.new(8)  do |row|
      Array.new(8) do |col|
        if row == 0 || row == 7
          command_row([row,col])
        elsif row == 1 || row == 6
          pawn_row([row,col])
        else
          BLANK_SPACE
        end
      end
    end
  end

  def pawn_row(coords)
    color = coords[0] == 1 ? :black : :white
    Pawn.new(self, coords, color)
  end

  def command_row(coords)
    color = coords[0] == 0 ? :black : :white
    case coords.last
      when 0 ; Rook.new(self, coords, color)
      when 1 ; Knight.new(self, coords, color)
      when 2 ; Bishop.new(self, coords, color)
      when 3 ; King.new(self, coords, color)
      when 4 ; Queen.new(self, coords, color)
      when 5 ; Bishop.new(self, coords, color)
      when 6 ; Knight.new(self, coords, color)
      when 7 ; Rook.new(self, coords, color)
    else
      raise "error"
    end
  end



end
