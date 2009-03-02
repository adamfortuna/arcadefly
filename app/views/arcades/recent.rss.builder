cache(:recent_arcades, :expires_in => 1.hour) do

xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Recent Arcades at ArcadeFly"
    xml.description "Most recent arcades added to ArcadeFly.com"
    xml.link arcades_url(:format => :rss)
    
    for arcade in @arcades
      xml.item do
        xml.title "Arcade added to ArcadeFly.com: #{arcade.name}"
        xml.description "#{arcade.name}, in #{arcade.address.shortest_line}, was added to ArcadeFly on #{arcade.created_at.strftime('%m/%d/%Y') + arcade.created_at.strftime(' at %I:%M %p')}, and so far has #{pluralize(arcade.playables.size, 'game')} available and has been favorited by #{pluralize(arcade.frequentships.size, 'player')}. #{link_to 'View this arcade on ArcadeFly', arcade_url(arcade, :format=>nil)}."
        xml.pubDate arcade.created_at.to_s(:rfc822)
        xml.link arcade_url(arcade, :format=>:html)
        xml.guid arcade_url(arcade, :format=>:html)
      end
    end
  end
end


end