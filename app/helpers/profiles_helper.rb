require 'avatar/view/action_view_support'

module ProfilesHelper
  include Avatar::View::ActionViewSupport
  
  
  def location_link profile = @p
    return profile.address.short_line if profile.has_address?
    link_to h(profile.address.short_line), search_profiles_path #.add_param('search[location]' => profile.address.short_line)
  end
  
  def unfriend_profile_link(profile, options = {})
    options.reverse_merge!({:show_text => false, :text => "Remove from your friends"})
    text = options[:show_text] ? " " + options[:text] : ''
    link_to_remote(image_tag("#{ASSET_HOST}/images/icons/user_delete.png", :size => "16x16", :border => 0) + text, 
                       :url => profile_friends_path(profile),
                       :method => :delete,
                       :with => "'show_text=#{options[:show_text]}'")
  end

  def friend_profile_link(profile, options = {})
    options.reverse_merge!({:show_text => false, :text => "Add as a friend"})
    text = options[:show_text] ? " " + options[:text] : ''
    link_to_remote(image_tag("#{ASSET_HOST}/images/icons/user_add.png", :size => "16x16", :border => 0) + text, 
                       :url => profile_friends_path(profile),
                       :with => "'show_text=#{options[:show_text]}'")
  end
end
