# Methods added to this helper will be available to all templates in the application.
require 'avatar/view/action_view_support'

module ApplicationHelper
  include Avatar::View::ActionViewSupport
  include FriendsHelper
  include TemplateHelper
  include GamesHelper
  include ArcadesHelper
  include TagsHelper
  
  def separator
    " &#8250; "
  end
  
  # Return a link for use in site navigation.
  def nav_link(text, link, options = {})
    #controller, action="index", show_link=true , css_class='')
    options.reverse_merge! :li_class => '', :show_link => true, :a_class => ''
    if current_page?(link)
      if options[:show_link]
        "<li class=\"current #{options[:li_class]}\">#{link_to text, link, :class => options[:a_class]}</li>"
      else
        "<li class=\"current #{options[:li_class]}\">#{text}</li>"
      end
    else
      "<li class=\"#{options[:li_class]}\">#{link_to text, link, :class => options[:a_class]}</li>"
    end
  end
  
  def menu_link(text, link, options = {})
    options.reverse_merge! :a_class => [], :li_class => []

    # If there is only one option passed in, convert it to an array
    options[:li_class] = Array.new([options[:li_class]]) if options[:li_class].class == String
    #options[:li_class].push("current") if current_page?(link)
    options[:li_class].push("current") if request.path_info == link
    
    content_tag :li, menu_a(text,link, options), :class => options[:li_class].length > 0 ? options[:li_class].join(' ') : nil
  end
  
  def menu_a(text, link, options = {})
    options[:a_class] = Array.new([options[:a_class]]) if options[:a_class].class == String
    link_to text, link, { :class => options[:a_class].length > 0 ? options[:a_class].join(' ') : nil }
  end
  
  # Used in views to set the page title for the layout
  def title(page_title)
    @title = page_title
    content_for(:title) { page_title }
  end
  
  # Adds a javascript file to the header
  def javascript_file(*files)
    content_for(:javascript) { javascript_include_tag(*files) }
  end
  
  # Adds a stylesheet file to the header
  def stylesheet(*files)
    content_for(:header) { stylesheet_link_tag(*files) }
  end

  def icon profile, size = :small, img_opts = {}
    return "" if profile.nil?
    img_opts = {:title => profile.display_name, :alt => profile.display_name, :class => "#{size} framed left"}.merge(img_opts)
    link_to(avatar_tag(profile, {:size => size, :file_column_version => size }, img_opts), profile_path(profile))
  end
  
  def me
    logged_in? && !@profile.nil? && (@profile == current_profile)
  end
  
  def map_bubble_for(addressable)
    render :partial => "#{addressable.class.to_s.downcase}s/map_bubble", :object => addressable
  end
end