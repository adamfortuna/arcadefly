# This describes what games are available a given arcade, and which arcades have a given game.
# 
class Playable < ActiveRecord::Base
  belongs_to :arcade, :counter_cache => true
  belongs_to :game, :counter_cache => true

  # Todo: Additional functionality for controlling quantity of games at an arcade.
  #  If an arcade has 3 copies of a game it will be shown within this model.
end