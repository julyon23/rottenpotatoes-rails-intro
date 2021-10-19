class Movie < ActiveRecord::Base
  def self.all_ratings
    return ['G','PG','PG-13','R']
  end
  def self.with_ratings(ratings)
    return ratings.present? ? Movie.where(rating: ratings.keys) : Movie.all
  end
end
