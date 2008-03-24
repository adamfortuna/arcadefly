# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  # Return a link for use in site navigation.
  def nav_link(text, controller, action="index", show_link=true , css_class='')
    if current_page?(:action => action, :controller => controller)
      if show_link
        "<li class=\"current #{css_class}\">#{link_to text, :action => action, :controller => controller}</li>"
      else
        "<li class=\"current #{css_class}\">#{text}</li>"
      end
    else
      "<li class=\"#{css_class}\">#{link_to text, :action => action, :controller => controller }</li>"
    end
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