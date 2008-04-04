# This controls which games users enjoys. 
class Favoriteship < ActiveRecord::Base
  belongs_to :game, :counter_cache => true
  belongs_to :user
end
