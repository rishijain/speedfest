require 'gosu'
require './components/testing_word.rb'

class Game < Gosu::Window

  def initialize
    super 800, 600, false
    self.caption = 'Type motherfucker type.'

    @score = 0
    @word_position = 0
    @input_area = Gosu::Font.new(self, Gosu::default_font_name, 35)
    @input = ''
    @test_words = []
    alpha_range = ('a'..'z')
    number_range = (1..9)
    @num_to_char_hash = find_conversion(alpha_range, 4)
    @num_to_char_hash.merge!(find_conversion(number_range, 30)).merge!({39 => 0})
    test_word_list = ['rishi', 'jain', 'is', 'game']
    test_word_list.each_with_index {|d, index| @test_words << TestingWord.new(self, 400 * (index+1), 80, d)}
    @game_started = true
  end

  def draw
    @input_area.draw(@input, 150, 60, 0, 1, 1, 0xff_ffffff)
    draw_objects(@test_words)
  end

  def draw_objects(objects)
    objects.each(&:draw)
  end

  def remove_current_word_from_list
    @test_words.delete(@current_word)
  end

  def move_words_into_position
    @test_words.each {|d| d.x = d.x - 400}
  end

  def check_if_input_matches?
    @current_word.word == @input
  end

  def button_down(id)
    if id == 40 #enterkey
      @score += 10 if check_if_input_matches?
      reset_input_to_blank
      remove_current_word_from_list
      move_words_into_position
    elsif id == 42 #backspace
      close
    elsif id == Gosu::KbEscape
      close
    else
      @input << @num_to_char_hash[id].to_s
    end
  end

  def reset_input_to_blank
    @input = ''
  end

  def get_current_word(position)
    @test_words[position]
  end

  def update
    @current_word = get_current_word(@word_position)
  end

  private

  def find_conversion(range, start_index=0)
    range.inject({}) {|d, k| d[range.find_index(k) + start_index] = k; d}
  end
end

game = Game.new
game.show
