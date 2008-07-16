# Methods added to this helper will be available to all templates in the application.
require 'avatar/view/action_view_support'

module ApplicationHelper
  include Avatar::View::ActionViewSupport
  include FriendsHelper
  include PhotosHelper
  include TemplateHelper
  
  def separator
    " &#8250; "
  end
  
  def less_form_for name, *args, &block
    options = args.last.is_a?(Hash) ? args.pop : {}
    options = options.merge(:builder=>LessFormBuilder)
    args = (args << options)
    form_for name, *args, &block
  end
  
  def less_remote_form_for name, *args, &block
    options = args.last.is_a?(Hash) ? args.pop : {}
    options = options.merge(:builder=>LessFormBuilder)
    args = (args << options)
    remote_form_for name, *args, &block
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
    options[:li_class].push("current") if current_page?(link)
    
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
  def javascript(*files)
    content_for(:head) { javascript_include_tag(*files) }
  end
  
  # Adds a stylesheet file to the header
  def stylesheet(*files)
    content_for(:head) { stylesheet_link_tag(*files) }
  end

  def me
    logged_in? && @profile == current_user.profile
  end
  
  def inline_tb_link link_text, inlineId, html = {}, tb = {}
    html_opts = {
      :title => '',
      :class => 'thickbox'
    }.merge!(html)
    tb_opts = {
      :height => 300,
      :width => 400,
      :inlineId => inlineId
    }.merge!(tb)
    
    path = '#TB_inline'.add_param(tb_opts)
    link_to(link_text, path, html_opts)
  end
  
  def tb_video_link youtube_unique_path
    return if youtube_unique_path.blank?
    youtube_unique_id = youtube_unique_path.split(/\/|\?v\=/).last.split(/\&/).first
    p youtube_unique_id
    client = YouTubeG::Client.new
    video = client.video_by YOUTUBE_BASE_URL+youtube_unique_id rescue return "(video not found)"
    id = Digest::SHA1.hexdigest("--#{Time.now}--#{video.title}--")
    inline_tb_link(video.title, h(id), {}, {:height => 355, :width => 430}) + %(<div id="#{h id}" style="display:none;">#{video.embed_html}</div>)
  end
  
  def icon profile, size = :small, img_opts = {}
    return "" if profile.nil?
    img_opts = {:title => profile.full_name, :alt => profile.full_name, :class => "#{size} framed left"}.merge(img_opts)
    link_to(avatar_tag(profile, {:size => size, :file_column_version => size }, img_opts), profile_path(profile))
  end
  
  def x_feed_link feed_item
    link_to_remote image_tag('delete.png', :class => 'png', :width=>'12', :height=>'12'), :url => profile_feed_item_path(@profile, feed_item), :method => :delete
  end
  
  def blogs_li blogs
    html = ''
    blogs.each do |b|
      html += "<li>#{link_to b.title, profile_blog_path(@profile, b)} written #{time_ago_in_words b.created_at} ago</li>"
    end
    html
  end
end