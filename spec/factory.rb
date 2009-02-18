require 'factory_girl'

Factory.sequence :region_name do |n|
  "region#{n}"
end
Factory.sequence :two_letter_abbreviation do |n|
  first = (n/26).to_i + 65
  second = (n%26) + 65
  first.chr + second.chr
end
Factory.sequence :three_letter_abbreviation do |n|
  "%03d"%n
end
Factory.sequence :country_name do |n|
  "country#{n}"
end


Factory.define :addressable, { :class => 'arcade' } do |u|
  u.name "Rock's Replay"
  u.permalink 'rockys-replay'
  u.phone '(407) 123-4567'
  u.website 'http://www.rockysreplay.com'
  u.notes 'Some notes about this arcade.'
  u.playables_count 10
  u.frequentships_count 10
  u.association :address
end

Factory.define :arcade do |u|
  u.name "Rock's Replay"
  u.permalink 'rockys-replay'
  u.phone '(407) 123-4567'
  u.website 'http://www.rockysreplay.com'
  u.notes 'Some notes about this arcade.'
  u.playables_count 10
  u.frequentships_count 10
  u.association :address
end

Factory.define :address do |u|
  u.title "Arcade"
  u.street  '1130 Summer Lakes Drive'
  u.city 'Orlando'
  u.postal_code '32835'
  u.lat 10
  u.lng 20
  u.association :region
  u.association :country
  u.geocoded true
end

Factory.define :region do |u|
  u.name { |s| s.name = Factory.next(:region_name) }
  u.abbreviation { |s| s.abbreviation = Factory.next(:two_letter_abbreviation) }
  u.association :country
end

Factory.define :country do |u|
  u.name { |s| s.name = Factory.next(:country_name) }
  u.alpha_2_code { |s| s.alpha_2_code = Factory.next(:two_letter_abbreviation) }
  u.alpha_3_code { |s| s.alpha_3_code = Factory.next(:three_letter_abbreviation) }
end