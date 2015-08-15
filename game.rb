require 'gosu'
require './components/testing_word.rb'

class Game < Gosu::Window

  def initialize
    super 800, 600, false
    self.caption = 'Type motherfucker type.'

    @input_area = Gosu::Font.new(self, Gosu::default_font_name, 35)
    @input = ''
    @test_words = []
    alpha_range = ('a'..'z')
    number_range = (1..9)
    @num_to_char_hash = find_conversion(alpha_range, 4)
    @num_to_char_hash.merge!(find_conversion(number_range, 30)).merge!({39 => 0})
    test_word_list = ['rishi', 'jain', 'is', 'game']
    test_word_list.each_with_index {|d, index| @test_words << TestingWord.new(self, 120,80 , d)}
  end

  def draw
    @input_area.draw(@input, 150, 60, 0, 1, 1, 0xff_ffffff)
    draw_objects(@test_words)
  end

  def draw_objects(objects)
    objects.each(&:draw)
  end

  def button_down(id)
    if id == 40 #enterkey
    elsif id == 42 #backspace
      close
    elsif id == Gosu::KbEscape
      close
    else
      @input << @num_to_char_hash[id].to_s
    end
  end

  def update
  end

  private

  def find_conversion(range, start_index=0)
    range.inject({}) {|d, k| d[range.find_index(k) + start_index] = k; d}
  end
end

game = Game.new
game.show
