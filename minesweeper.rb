require './board.rb'
require './tile.rb'

class Minesweeper

  def initialize(difficulty = 1)
    @board = Board.new(difficulty)
  end

  def get_action
    puts "Please enter action (f = flag, r = reaveal): "
    gets.chomp
  end

  def get_pos
    puts "Please enter a position 'x,y': "
    gets.chomp
  end

  def play_turn
    system('clear')
    @board.render
    action = get_action
    pos = get_pos.split(",").map(&:to_i)
    @board.click(pos, action)
  end

  def play
    until @board.game_over || @board.won?
      play_turn
    end
    @board.won_game
  end

end

ms = Minesweeper.new
ms.play
