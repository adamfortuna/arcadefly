require 'rubygems'  
require 'xmpp4r-simple'
messenger = Jabber::Simple.new('bot@arcadefly.com', "superbot")
welcome = "Hey there! I'm ArcadeFly's jabber implementation. I can be used anywhere for some quick access to arcade and game locations."
while true
  messenger.received_messages do |msg|
    puts "Message from '#{msg.from}' with text '#{msg.body}'"
    puts msg.from.domain
    # profile = Profile.find_by_gtalk_name("#{msg.from.node}@#{msg.from.domain}")
    # if profile
    #   messenger.deliver(msg.from, "#{welcome} Oh hey, I remember you. Welcome back #{profile.display_name}.")  
    # else
    #   messenger.deliver(msg.from, "#{welcome} Looks like you're new here; here's how I work:")  
    # end
    
    case msg.body
    when /^help/i
      messenger.deliver(msg.from, "Valid commands are......")
      messenger.deliver(msg.from, "* arcades near <address>. Example: 'arcades near 32819'.  Address can be just a city or zip code. ")
      #messenger.deliver(msg.from, "* <game> near <your address here>. Example: 'ddr supernova near 32819'.  Address can be just a city or zip code.")
    when /^arcades near /i
      location = msg.body.match(/arcades near /).post_match
      address = Address.geocode(location)
      arcades = Arcade.paginate({:origin => address,
                                 :order => "distance",
                                 :include => {:address => [:region, :country]},
                                 :page => 1,
                                 :per_page => 10})
      
      messenger.deliver(msg.from, "Here are some arcades near #{location}. Found #{arcades.length} locations")
      arcades.each_with_index do |arcade, index|
        messenger.deliver(msg.from, "#{index+1}. #{arcade.name} (#{arcade.address.distance_to(address).round_to(2)} miles/#{arcade.playables_count} games/ #{arcade.frequentships_count} favorites) - #{arcade.address.street}, #{arcade.address.city}, #{arcade.address.postal_code}. Map this: http://maps.google.com/?q=#{CGI.escape(arcade.address.single_line)} or ArcadeFly: #{HOST}/arcades/#{arcade.permalink}")
      end
    # when / near /i
    #   match = msg.body.match(/ near /)
    #   location = match.post_match
    #   game = match.pre_match
    #   messenger.deliver(msg.from, "Here are some games... looking for #{game} near #{location}")  
    else
      messenger.deliver(msg.from, "#{welcome}. Message me with 'help' for a list of commands.")  
    end
  end  
  sleep 2  
end