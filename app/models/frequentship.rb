# This controls which arcades users frequent. This is how the site tracks which arcades
# the user wants to watch, as well as determine how popular an arcade is. A user can make
# an arcade their favorite and it's associated here.
class Frequentship < ActiveRecord::Base
  belongs_to :arcade, :counter_cache => true
  belongs_to :user, :counter_cache => true
end
