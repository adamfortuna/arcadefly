# This controls which games users enjoys. 
class Favoriteship < ActiveRecord::Base
  belongs_to :game, :counter_cache => true
  belongs_to :user, :counter_cache => true
  
  after_destroy :update_favoriteships_count
  
  private
  def update_favoriteships_count
    game.save
    user.save
  end
end
