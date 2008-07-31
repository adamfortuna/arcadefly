module GamesHelper
  
  def favorite_game_link(game, options = {})
    options.reverse_merge!({:show_text => false, :text => "Add to your favorites"})
    text = options[:show_text] ? " " + options[:text] : ''
    link_to_remote(image_tag("/images/icons/controller_add.png", :size => "16x16", :border => 0) + text, 
                       :url => favorite_game_path(game), 
                       :with => "'show_text=#{options[:show_text]}'")
  end

  def unfavorite_game_link(game, options = {})
    options.reverse_merge!({:show_text => false, :text => "Remove from your favorites"})
    text = options[:show_text] ? " " + options[:text] : ''
    link_to_remote(image_tag("/images/icons/controller_delete.png", :size => "16x16", :border => 0) + text, 
                       :url => unfavorite_game_path(game),
                       :with => "'show_text=#{options[:show_text]}'")
  end
end