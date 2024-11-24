class Genre < ActiveRecord::Base
  translates :name, :description
end
