require 'json'
require 'open-uri'

class PagesController < ApplicationController
  def new
    @array = generate_random_letters
  end

  def result
    @array = params[:array].split(" ")
    hashed
    @answer = params[:word]
    @url = "https://wagon-dictionary.herokuapp.com/#{@answer}"
    answer_treatment
  end

  private

  def generate_random_letters
    (1..10).to_a.map { ('a'..'z').to_a[rand(26)] }
  end

  def hashed
    @hash = {}
    @array.each do |letter|
      key = letter.to_sym
      @hash.keys.include?(key) ? @hash[key] += 1 : @hash[key] = 1
    end
    @hash
  end

  def answer_treatment
    online_answer = open(@url).read
    file = JSON.parse(online_answer)
    if file[:found]
      hash_values_update
    else
      @message = "Word does not exist"
    end
    hash_values_update
  end

  def hash_values_update
    @answer.split("").each do |letter|
      if @hash.keys.include?(letter.to_sym)
        @hash[letter.to_sym] =- 1
      else
        @hash[letter.to_sym] = -1
      end
    end
    @message = "Word exists!"
    @hash.values.each {|value| @message = "Word does not respect letter count!" if value < 0}
  end
end
