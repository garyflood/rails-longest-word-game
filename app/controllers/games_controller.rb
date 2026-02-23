require "open-uri"
require "json"

class GamesController < ApplicationController
  def new
    grid_size = 10
    @letters = []
    while grid_size.positive?
      @letters << ("A".."Z").to_a[rand(26)]
      grid_size -= 1
    end
    session[:letters] = @letters
  end
  def score
    @points = 0
    if valid_word?(params[:score].upcase)
      response_serialized = URI.parse("https://dictionary.lewagon.com/#{params[:score]}").read
      response = JSON.parse(response_serialized)
      if response["found"]
        @points = params[:score].length
        @reponse = "You win!"
      else
        @reponse = "This word is not in the dictionary"
      end
    else
      @reponse = "Sorry but " + params[:score] + " cannot be built out of " + session[:letters].join("-")
    end
  end

  def valid_word?(word)
    letters = session[:letters]
    word.each_char do |c|
      if letters.include?(c)
        index = letters.index(c)
        letters.delete_at(index)
      else
        return false
      end
    end
    true
  end
end
