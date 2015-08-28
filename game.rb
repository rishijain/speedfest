require 'gosu'
require './components/testing_word.rb'

class Game < Gosu::Window

  def initialize
    super 800, 600, false
    self.caption = 'Type motherfucker type.'

    @bg = Gosu::Image.new self, 'bg.png'
    @lame = Gosu::Image.new self, 'lame.jpg'
    @time_monitor = 0 #value is in seconds
    @round = 1
    @game_title = Gosu::Font.new(self, Gosu::default_font_name, 50)
    @final_score = Gosu::Font.new(self, Gosu::default_font_name, 30)
    @time_monitor_text = Gosu::Font.new(self, Gosu::default_font_name, 50)
    @score = 0
    @score_value = Gosu::Font.new(self, Gosu::default_font_name, 35)
    @word_position = 0
    @input_area = Gosu::Font.new(self, Gosu::default_font_name, 35)
    @input = ''
    @test_words = []
    alpha_range = ('a'..'z')
    number_range = (1..9)
    @num_to_char_hash = find_conversion(alpha_range, 4)
    @num_to_char_hash.merge!(find_conversion(number_range, 30)).merge!({39 => 0})
    test_word_list = (easy_words + medium_words + hard_words).sample(20)
    test_word_list.each_with_index {|d, index| @test_words << TestingWord.new(self, 400 * (index+1), 80, d)}
    @game_running = true
    @count = 0
    @time_left = 50
    @keypress = Gosu::Song.new(self, "keypress.mp3")
  end

  def draw
    if @time_left > 0
      @bg.draw 0,0,0
      @time_monitor_text.draw("Time left: #{@time_left}", 200, 150, 0, 1, 1, 0xff_0000ff)
      @game_title.draw("Speedfest", 300, 10, 0, 1, 1, 0xff_0000ff)
      @score_value.draw("Score: #{@score}", 150, 40, 0, 1, 1, 0xff_ffffff)
      @input_area.draw(@input, 150, 60, 0, 1, 1, 0xff_ffffff)
      draw_objects(@test_words)
    else
      @final_score.draw("You got #{@score/10} words right.", 200, 200, 0, 1, 1, 0xff_0000ff)
      @final_score.draw("#{final_score_message}", 100, 250, 0, 1, 1, 0xff_0000ff)
      @current_word.x -= 800
      @time_monitor_text.draw("Time left: #{@time_left}", -400, 150, 0, 1, 1, 0xff_0000ff)
      @game_title.draw("Speedfest", -300, 10, 0, 1, 1, 0xff_0000ff)
      @score_value.draw("Score: #{@score}", -300, 40, 0, 1, 1, 0xff_ffffff)
      @input_area.draw(@input, -300, 60, 0, 1, 1, 0xff_ffffff)
    end
  end

  def button_down(id)
    if id == 40 #enterkey
      @score += 10 if check_if_input_matches?
      assign_round
      reset_input_to_blank
      remove_current_word_from_list
      move_words_into_position
    elsif id == 42 #backspace
      @game_running = false
      close
    elsif id == Gosu::KbEscape
      close
    else
      @keypress.play(false)
      @input << @num_to_char_hash[id].to_s
    end
  end

  def update
    update_time_monitor
    @current_word = get_current_word(@word_position)
    current_word_movement_for_round_2 if @round == 2
    current_word_movement_for_round_3 if @round == 3
  end

  private

  def update_time_monitor
    @count += 1
    if @count%60 == 0
      @time_monitor += 1
      @time_left -= 1
    end
  end

  def easy_words
    ['owed', 'plows', 'smart', 'snare', 'rails', 'dares', 'wears', 'lairs', 'liars', 'pails',
      'slaps', 'jails', 'kills', 'flick', 'pokes', 'ruins', 'rakes', 'jewel', 'plead']
  end

  def medium_words
    ['equipment', 'apparent', 'intelligence', 'medieval', 'weird', 'rhythm']
  end

  def hard_words
    ['amateur', 'bellwether', 'believe', 'cemetery', 'conscience', 'conscientious', 'leisure', 'conviviality', '']
  end

  def current_word_movement_for_round_2
    @current_word.x -= 3
  end

  def current_word_movement_for_round_3
    @current_word.y += rand(-4..10)
    @current_word.x -= rand(-10..10)
  end

  def assign_round
    if @score >= 30 and @score < 60
      @round = 2
    elsif @score >= 60
      @round = 3
    end
  end

  def find_conversion(range, start_index=0)
    range.inject({}) {|d, k| d[range.find_index(k) + start_index] = k; d}
  end

  def reset_input_to_blank
    @input = ''
  end

  def get_current_word(position)
    @test_words[position]
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

  def final_score_message
    if @score < 60
      @lame.draw 0,0,0
      return 'I have no words to describe this performance.'
    elsif @score >= 60 and @score < 120
      return 'Just go and practise and practise and practise bcoz it will never be enough for you ..!!'
    elsif @score >= 120 and @score < 190
      return 'You are alright ... nothing special about you.'
    elsif @score == 200
      return 'My Lord .. I have been looking for you for ages and I have finally found you.'
    end
  end
end

game = Game.new
game.show
