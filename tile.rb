class Tile

  attr_reader :value

  def initialize(value = 0)
   @flag = false
   @bomb = false
   @value = value
   @revealed = false
  end

  def reveal
    @revealed = true
  end

  def set_flag
    @flag = !@flag
  end

  def set_bomb
    @bomb = true
  end

  def add_val
    @value += 1
  end

  def flagged?
    @flag
  end

  def bomb?
    @bomb
  end

  def revealed?
    @revealed
  end
end
