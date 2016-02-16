class Array
  def deep_dup
    map { |el| Array(el) == el ? el.deep_dup : el }
  end
end

class ChessError < StandardError
end
