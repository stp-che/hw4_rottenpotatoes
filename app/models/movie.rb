class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end

  def similars_by_director
    Movie.where("director = :director AND id != :id", {:director => self.director, :id => self.id}).all
  end

end
