require './board.rb'
require './tile.rb'
require 'yaml'

class Minesweeper

  def initialize(difficulty = 1)
    @board = Board.new(difficulty)
  end

  def get_action
    puts "Please enter action (f = flag, r = reaveal, s = save): "
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
    if action == "s"
      save_game
      play_turn
    end
    pos = get_pos.split(",").map(&:to_i)
    @board.click(pos, action)
  end

  def play
    if @board.empty?
      puts "Do you want to continue your game? (y/n): "
      load_game if gets.chomp == 'y'
    end

    until @board.game_over || @board.won?
      play_turn
    end
    @board.won_game
  end

  def save_game
    File.open("minesweeper_save.yml" ,"w+") do |file|
      file.puts self.to_yaml
    end
  end

  def load_game
    game = YAML::load(File.open("minesweeper_save.yml"))
    game.play
  end

end

if $PROGRAM_NAME == __FILE__
  ms = Minesweeper.new
  ms.play
end
