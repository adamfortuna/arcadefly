# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

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
    options[:li_class].push("current") if current_page?(link)
    
    content_tag :li, menu_a(text,link, options), :class => options[:li_class].length > 0 ? options[:li_class].join(' ') : nil
  end
  
  def menu_a(text, link, options = {})
    options[:a_class] = Array.new([options[:a_class]]) if options[:a_class].class == String
    link_to text, link, { :class => options[:a_class].length > 0 ? options[:a_class].join(' ') : nil }
  end
  
  # Used in views to set the page title for the layout
  def title(page_title)
    content_for(:title) { page_title }
  end
  
  # Adds a javascript file to the header
  def javascript(*files)
    content_for(:head) { javascript_include_tag(*files) }
  end
  
  # Adds a stylesheet file to the header
  def stylesheet(*files)
    content_for(:head) { stylesheet_link_tag(*files) }
  end
 
  # User related helpers
  def current_user
    if logged_in?
      User.find(session[:user_id])
    else
      User.new
    end
  end
  
  # Return true if some user is logged in, false otherwise.
  def logged_in?
    not session[:user_id].nil
  end

  def role?(role = 'none')
    return logged_in? || true
  end
  
  
  #def script_gmap_with_key
  #  key = YAML::load(IO.read(RAILS_ROOT + '/config/gmap.yml'))[ENV['RAILS_ENV']][request.host]
  #  "<script src='http://maps.google.com/maps?file=api&amp;v=2&amp;key=#{key}' type='text/javascript'></script>"
  #end

end