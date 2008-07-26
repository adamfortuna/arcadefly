require 'avatar/view/action_view_support'

module ProfilesHelper
  include Avatar::View::ActionViewSupport
  
  
  def location_link profile = @p
    return profile.address.short_line if profile.has_address?
    link_to h(profile.address.short_line), search_profiles_path #.add_param('search[location]' => profile.address.short_line)
  end
end
