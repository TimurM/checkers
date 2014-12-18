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
      ending_pos = prompt("to")
      @playing_board[starting_pos].perform_slide(ending_pos)

      puts @playing_board.render
      puts "player 2 turn "

      starting_pos = prompt("starting")
      ending_pos = prompt("to")
      @playing_board[starting_pos].perform_slide(ending_pos)
    end

  end

  def prompt(position)
    puts "Enter your #{position} position: "
    move = gets.chomp.split(",").map {|i| i.to_i }
    move
  end
end

g1 = Game.new
g1.play
