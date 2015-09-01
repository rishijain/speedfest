class TestingWord

  attr_accessor :x, :y, :word

  def initialize(window, x, y, word)
    @x = x
    @y = y
    @word = word
    @input_area = Gosu::Font.new(window, "fonts/badabb.TTF", 80)
  end

  def draw
    @input_area.draw(@word, @x, @y, 0, 1, 1, 0xff_ffffff)
  end

  def update
  end

  private
end
