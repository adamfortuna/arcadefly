class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include HoptoadNotifier::Catcher

  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => 'arcadefly_session_id'

  # Sort this addressable by the distance from the current address
  def sort_by_distance(addressables)
    (addressables && addressables.length > 1 && addressed_in?) ? addressables.sort_by_distance_from(current_address) : addressables
  end
  
  # Create a map object for an array of arcades
  def map_for_array(addressables, options = {})
    options.reverse_merge!({:small_map => true, :map_type => false, :id => "#{addressables.first.class.to_s.downcase}_map"})
    map = GMap.new(options[:id])
    map.control_init(options)
    map.center_zoom_init([26,-80], 6)

    markers = {}
    addressables.each do |addressable|
      markers.merge!("'#{addressable.permalink}'" => GMarker.new([addressable.address.lat, addressable.address.lng],
                             :title => addressable.name,
                             :info_window => addressable.map_bubble))
    end
    
    gmarker_group = GMarkerGroup.new(true, markers)
    map.overlay_global_init(gmarker_group,"#{addressables.first.class.to_s.downcase}_group")

    sorted_latitudes = addressables.collect(&:address).collect(&:lat).compact.sort
    sorted_longitudes = addressables.collect(&:address).collect(&:lng).compact.sort
    map.center_zoom_on_bounds_init([ [sorted_latitudes.first, sorted_longitudes.first], 
                                     [sorted_latitudes.last, sorted_longitudes.last]])
    map
  end
end
