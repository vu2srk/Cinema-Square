class Movie < ActiveRecord::Base
  attr_accessible :movie_url, :pic_url, :user_id
  belongs_to :user
end
