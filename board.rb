require './tile.rb'

class Board
  attr_reader :game_over

  def []=(pos, val)
    @grid[pos[0]][pos[1]] = val
  end

  def [](pos)
    @grid[pos[0]][pos[1]]
  end

  def initialize(difficulty = 1)
    @grid = Array.new(9) { Array.new(9) }
    @difficulty = difficulty
    @game_over = false
    @won = false
    populate
  end

  def populate
    @grid.each_with_index do |row, idx|
      row.each_index do |col|
        @grid[idx][col] = Tile.new
      end
    end
    set_bombs
  end

  def set_bombs
    position_vals = (0...9).to_a.concat((0...9).to_a)
    positions = position_vals.repeated_permutation(2).to_a
    positions.shuffle!

    (@difficulty * 10).times do
      pos = positions.pop
      self[pos].set_bomb
      set_adj_vals(adj_tiles(pos))
    end
  end

  def adj_tiles(pos)
    row = pos[0]
    col = pos[1]
    adjs = []
    (row-1..row+1).each do |adj_row|
      (col-1..col+1).each do |adj_col|
        adjs << [adj_row, adj_col]
      end
    end
    adjs.reject! { |row, col| (row < 0 || row > 8) || (col < 0 || col > 8)}
    adjs.delete([row, col])
    adjs
  end

  def set_adj_vals(arr)
    arr.each do |pos|
      unless self[pos].bomb?
        self[pos].add_val
      end
    end
  end

  def render
    str = ""
    @grid.each do |row|
      row.each do |tile|
        if tile.flagged?
          str << " ! "
        elsif tile.bomb? && tile.revealed?
          str << " X "
        elsif tile.revealed?
          str << " #{tile.value} "
        else
          str << " - "
        end
      end
      str += "\n"
    end
    puts str
  end

  def click(pos, act = "r")
    if act == "s"
      return "s"
    elsif act == "f"
      self[pos].set_flag
      return nil
    elsif self[pos].bomb?
      lost_game
    elsif self[pos].value == 0 && !self[pos].bomb?
      self[pos].reveal
      adj_tiles(pos).each do |adj|
        unless self[adj].revealed?
          click(adj)
        end
      end
    else
      self[pos].reveal
    end
  end

  def won?
    @grid.each do |row|
      row.all? do |tile|
        return false if !tile.revealed? || tile.bomb?
      end
    end
    true
  end

  def won_game
    system('clear')
    @grid.each do |row|
      row.each do |tile|
        tile.reveal
        tile.set_flag if tile.flagged?
      end
    end
    render
    puts "YOU WIN"
    @won = true
  end

  def lost_game
    system('clear')
    @grid.each do |row|
      row.each do |tile|
        tile.reveal
        tile.set_flag if tile.flagged?
      end
    end
    render
    puts "GAME OVER"
    @game_over = true
  end

  def empty?
    @grid.each do |row|
      row.each do |tile|
        return false if tile.revealed?
      end
    end
    true
  end

end
