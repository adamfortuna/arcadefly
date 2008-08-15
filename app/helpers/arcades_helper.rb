module ArcadesHelper
  def add_game_link(name)
    link_to_function name do |page| 
      page.insert_html :bottom, :games, :partial => 'game', :object => Game.new
    end
  end
  
  
  def favorite_arcade_link(arcade, options = {})
    options.reverse_merge!({:show_text => false, :text => "Add to your favorites"})
    text = options[:show_text] ? " " + options[:text] : ''
    link_to_remote(image_tag("#{ASSET_HOST}/images/icons/joystick_add.png", :size => "16x16", :border => 0) + text, 
                       :url => favorite_arcade_path(arcade), 
                       :with => "'show_text=#{options[:show_text]}'")
  end

  def unfavorite_arcade_link(arcade, options = {})
    options.reverse_merge!({:show_text => false, :text => "Remove from your favorites"})
    text = options[:show_text] ? " " + options[:text] : ''
    link_to_remote(image_tag("#{ASSET_HOST}/images/icons/joystick_delete.png", :size => "16x16", :border => 0) + text, 
                       :url => unfavorite_arcade_path(arcade),
                       :with => "'show_text=#{options[:show_text]}'")
  end
  
  
end