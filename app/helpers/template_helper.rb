module TemplateHelper

  def create_template(header, footer, &block)
    # Get the data from the block 
    data = capture(&block)
    res = header + data + footer

    # Use concat method to pass text back to the view 
    concat(res)
  end

  def tabbed_box(&block)
    a = '<div class="block_outside_topless"><div class="block_inside_topless">'
    b = '</div></div>'
    create_template(a, b, &block)
  end

  def box(&block)
    a = '<div class="block_outside"><div class="block_inside">'
    b = '</div></div>'
    create_template(a, b, &block)
  end

  def sidebar(&block)
    a = '<div id="sidebar"><div class="block_inside">'
    b = '</div></div>'
    create_template(a, b, &block)
  end
  
  def content_area(&block)
    a = '<div id="content_area" class="block_outside"><div class="block_inside">'
    b = '</div></div>'
    create_template(a, b, &block)
  end
  
  def list_box(&block)
    a = '<div class="block_outside"><div class="block_inside">'
    b = '</div></div>'
    create_template(a, b, &block)
  end
end