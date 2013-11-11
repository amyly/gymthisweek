require 'foursquare2'

client = Foursquare2::Client.new(:client_id => 'UVAG0LCZ3XVQFVSTAN0MQ4KJNI0ZK4PH4DU1FXFCED15RE43', :client_secret => 'INFZEKJROG54HRPGKIHEI43CMWXR4XASNDRBO21I0HJJYTXI', :oauth_token => 'L00OM402V5PAK1RH512TYARV4P2KEEYI5KI0GORTYZO4RBOP')

# Currently gets Epoch time exactly 7 * 24 hours ago; need to update!
seven_days_ago = Time.now.to_i - 604800

# Gets checkins in specific category since seven_days_ago
checkins = Array.new
client.user_checkins(:afterTimestamp => seven_days_ago)["items"].map do |item|
  item["venue"]["categories"].map do |category|
    if category.name.include? "Restaurant"
      checkin = Hash.new
      checkin[:id] = item["id"]
      checkin[:time] = item["createdAt"]
      checkin[:shout] = item["shout"]
      checkin[:venue_name] = item["venue"][:name]
      checkin[:venue_id] = item["venue"][:id]
      checkin[:venue_address] = item["venue"]["location"][:address]
      checkin[:venue_lat] = item["venue"]["location"][:lat]
      checkin[:venue_long] = item["venue"]["location"][:long]
      checkin[:venue_city] = item["venue"]["location"][:city]
      checkin[:venue_state] = item["venue"]["location"][:state]
      checkin[:venue_country] = item["venue"]["location"][:country]
      checkins << checkin
    end
  end
end




puts checkins.length





def get_from_digg
  res = JSON.load(RestClient.get('http://digg.com/api/news/popular.json'))
  res["data"]["feed"].map do |story|
    s = {}
    s[:title] = story["content"]["title"]
    story["content"]["tags"].map do |tag|
      s[:category] = tag["display"]
    end
    calculate_upvotes s
    puts display_new_story(s)
  end
end
