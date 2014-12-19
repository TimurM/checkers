require_relative 'board'

class Game

  def initialize
    @playing_board = Board.new
  end

  def play

    while true
      puts @playing_board.render
      puts "player 1 turn "
      starting_pos = prompt("starting")
      ending_pos = to_prompt("to")
      @playing_board[starting_pos].perform_moves(ending_pos)

      puts @playing_board.render
      puts "player 2 turn "

      starting_pos = prompt("starting")
      ending_pos = to_prompt("to")
      @playing_board[starting_pos].perform_moves(ending_pos)
    end

  end

  def prompt(position)
    puts "Enter your #{position} position: "
    move = gets.chomp.split(",").map {|i| i.to_i }
    move
  end

  def to_prompt(position)
    move_seq = []
      i = 0
      while i < 2
        puts "Enter your #{position} position: "
        move = gets.chomp.split(",").map {|i| i.to_i }
        move_seq << move
        i +=1
      end
  end
end

g1 = Game.new
g1.play
