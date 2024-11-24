class Movie < ActiveRecord::Base
  translates :title, :description
end
