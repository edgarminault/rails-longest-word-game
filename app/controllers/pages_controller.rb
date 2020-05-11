class PagesController < ApplicationController

  def new
    generate_random_letters
  end

  private

  def generate_random_letters
    @array = (1..10).to_a.map { ('a'..'z').to_a[rand(26)] }
  end

end
