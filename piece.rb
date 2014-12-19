# -*- coding: utf-8 -*-

class Piece
  attr_accessor :king, :pos
  attr_reader :color, :board

  MOVE_SLIDE_DIFFS = [
    [-1, 1],
    [-1, -1],
    [1, -1],
    [1, 1]
  ]

  MOVE_JUMP_DIFFS = [
    [-2, 2],
    [-2, -2],
    [2, -2],
    [2, 2]
  ]



  def initialize(pos, color, board)
    @pos = pos
    @color = color
    @board = board
    @king = false

    board.add_piece(self, pos)
  end

  def inspect
    render + " " + @pos.inspect
  end

  def render
    if color == :White && king == true
      "♔"
    elsif color == :White
      "♙"
    elsif color == :Black && king == true
      "♚"
    elsif color == :Black
      "♟"
    end
  end

  def move_slide_diffs
    piece_diffs = []
    MOVE_SLIDE_DIFFS.each do |coord|
      if self.king
        piece_diffs << coord
      elsif self.color == :White
        piece_diffs << coord if coord[0] == -1
      elsif self.color == :Black
        piece_diffs << coord if coord[0] == 1
      end
    end
    piece_diffs
  end

  def move_jump_diffs
    piece_diffs = []
    MOVE_JUMP_DIFFS.each do |coord|
      if self.king
        piece_diffs << coord
      elsif self.color == :White
        piece_diffs << coord if coord[0] == -2
      elsif self.color == :Black
        piece_diffs << coord if coord[0] == 2
      end
    end
    piece_diffs
  end

  def perform_slide(to_pos)

    raise InvalidMove.new "This move is not on the board" unless board.valid_pos?(to_pos)

    move_slide_diffs.each do |diffs|
      x, y = diffs[0], diffs[1]
      maybe_move = [pos[0]+x, pos[1]+y]
      raise InvalidMove.new "This move is not valid -- position taken" if !board[to_pos].nil?

      if maybe_move == to_pos && board[to_pos].nil?
        self.king = true if promote_king?(to_pos)
        board[to_pos] = self
        board[pos] = nil
        self.pos = to_pos

        true
        break
      end
    end
    false
  end

  def perform_jump(to_pos)
    raise InvalidMove.new "This move is not on the board" unless board.valid_pos?(to_pos)
    opponents_piece_spot = nil

    move_jump_diffs.each do |diffs|
      x, y = diffs[0], diffs[1]
      maybe_move = [pos[0] + x, pos[1] + y]

      opponents_piece_spot = [pos[0] + x / 2, pos[1] + y / 2]
      opponents_piece = board[opponents_piece_spot]

      if !opponents_piece.nil? && opponents_piece.color == self.color
        raise InvalidMove.new "You can only jump over opponents pieces"
      end

      if maybe_move == to_pos && board[to_pos].nil? && !opponents_piece.nil? && opponents_piece.color != self.color
        board[to_pos] = self
        board[pos] = nil
        self.pos = to_pos

        self.king = true if promote_king?(to_pos)

        board[opponents_piece_spot] = nil
        true
        break
      end
    end
    false
  end

  def promote_king?(to_pos)
    if self.color == :White && to_pos[0] == 0
      return true
    elsif self.color == :Black && to_pos[0] == 7
      return true
    else
      return false
    end
  end

  def valid_move_seq?(array)
    board_copy = board.dup
    begin
      board_copy[pos].perform_moves!(array)
    rescue InvalidMoveError => e
      puts "Error was: #{e}"
      false
    end
    true
  end

  def perform_moves(array)

    if array.length < 2
      perform_slide(array.first)
      perform_jump(array.first)
    elsif array.length >= 1

      if valid_move_seq?(array)
        perform_moves!(array)
      else
        raise InvalidMoveError.new "Invalid sequence -- too short"
      end
    end
  end

  def perform_moves!(array)

    array.each {|el| perform_jump(el)}
  end

end

class InvalidMoveError < StandardError

end

class InvalidMove<StandardError

end
