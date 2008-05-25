module ArcadesHelper
  def add_game_link(name)
    link_to_function name do |page| 
      page.insert_html :bottom, :games, :partial => 'game', :object => Game.new
    end
  end
end