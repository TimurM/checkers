require_relative 'piece'

class Board
  attr_reader :grid, :render

  def initialize(fill_board = true)
    generate_board(fill_board)
  end

  def [](pos)
    i, j = pos
    @grid[i][j]
  end

  def []=(pos, piece)
    i, j = pos
    @grid[i][j] = piece
  end

  def add_piece(piece, pos)
    self[pos] = piece
  end

  def render
    @grid.map do |row|
      row.map do |piece|
        piece.nil? ? '_' : piece.render
      end.join
    end.join("\n")
  end

  def valid_pos?(pos)
    pos.all? {|coord| coord.between?(0,7)}
  end

  private

  def generate_board(fill_board)
    @grid = Array.new(8) {Array.new(8)}
    return board unless fill_board
    generate_pieces
  end

  def generate_pieces
    8.times do |row|
      (0..7).each do |el|
        if (row == 0 || row == 2) && el % 2 == 1
          Piece.new([row, el], :Black, self)
        elsif (row == 5 || row == 7) && el % 2 != 1
          Piece.new([row, el], :White, self)
        elsif (row == 1) && el % 2 != 1
          Piece.new([row, el], :Black, self)
        elsif (row == 6) && el % 2 == 1
          Piece.new([row, el], :White, self)
        end
      end
    end
  end

end


b1 = Board.new(true)
# p b1[[0,1]]
b1[[2,1]].perform_slide([3,0])
puts b1.render
puts
b1[[5,2]].perform_slide([4,1])
puts b1.render
puts
b1[[3,0]].perform_jump([5,2])
puts b1.render
puts
