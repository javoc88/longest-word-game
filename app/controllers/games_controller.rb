require 'open-uri'

class GamesController < ApplicationController
  VOWELS = %w(A E I O U Y)
  
  def new
    @letters = Array.new(5) {VOWELS.sample}
    @letters += Array.new(5) { (("A".."Z").to_a - VOWELS).sample }
    @letters.shuffle!
    # @start_time = Time.now
  end

  def score
    @letters = params[:letters].split
    @word = (params[:word] || "").upcase
    @included = included?(@word, @letters)
    @english_word = english_word?(@word)
    # @attempt = params[:attempt]
    # start_time = Time.parse(params[:start_time])
    # end_time = Time.now
    # @result = run_game(@attempt, letters, start_time, end_time)
  end

  
  private

  def included?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end

  # def compute_score(attempt, time_taken)
  #   (time_taken > 60.0) ? 0 :attempt.size * (1.0 - time_taken)
  # end

  # def run_game(attempt, grid, start_time, end_time)
  #   result = { time: end_time - start_time }
  #   result[:translation] = get_translation(attempt)
  #   result[:score], result[:message] = score_and_message(attempt, result[:translation], grid, result[:time])
  #   result
  # end

  # def score_and_message(attempt, translation, grid, time)
  #   if translation
  #     if included?(attempt.upcase, grid)
  #       score = compute_score(attempt, time)
  #       [score, "Great!"]        
  #     else
  #       [0, "Nope, not in the grid"]
  #     end
  #   else
  #     [0, "Are you writing in english?"]
  #   end
  # end

  # def get_translation(word)
  #   response = open("http://api.wordreference.com/0.8/80143/json/enfr/#{word.downcase}")
  #   json = JSON.parse(response.read.to_s)
  #   json['term0']['PrincipalTranslations']['0']['FirstTranslation']['term'] unless json["Error"]
  # end

end
