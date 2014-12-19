require_relative 'piece'
require 'colorize'

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

  def generate_board(fill_board)
    @grid = Array.new(8) {Array.new(8)}
    return @grid unless fill_board
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

  def dup
    new_board = Board.new(false)

    pieces.each do |piece|
      piece.class.new(piece.pos, piece.color, new_board)
    end

    new_board
  end

  def pieces
    @grid.flatten.compact
  end

end

class InvalidMoveError < StandardError

end

b1 = Board.new(true)
b1[[5,6]].perform_slide([4,7])
puts b1.render
puts "____________"
b1[[5,4]].perform_slide([4,5])
puts b1.render
puts "____________"
b1[[4,5]].perform_slide([3,4])
puts b1.render
puts "____________"
b1[[6,7]].perform_slide([5,6])
puts b1.render
puts "____________"
b1[[2,3]].perform_moves([[4,5], [6,7]])
puts b1.render

# p b1[[0,1]]
# b1[[2,1]].perform_slide([3,0])
# puts b1.render
# puts
# b1[[5,2]].perform_slide([4,1])
# puts b1.render
# puts
# b1[[3,0]].perform_jump([5,2])
# puts b1.render
# puts
