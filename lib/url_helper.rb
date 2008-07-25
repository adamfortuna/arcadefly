module UrlHelper
  
  def permalink
    raise "This should be overwritten with what you want to use as your permalink"
  end

  def to_param
    url_safe(permalink)
  end
  
  def url_safe(param)
    param.downcase.gsub(/[^[:alnum:]]/,'-').gsub(/-{2,}/,'-')
  end
  
end