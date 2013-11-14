class User < ActiveRecord::Base
  has_many :hashtags

  def self.from_omniauth(auth)
    where(auth.slice("provider", "uid")).first || create_from_omniauth(auth)
  end
  def self.create_from_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.first_name = auth["info"]["first_name"]
      user.last_name = auth["info"]["last_name"]
      user.email = auth["info"]["email"]
      user.foursquare_token = auth["credentials"]["token"]
    end
  end

  def get_checkins(current_user)
    client = Foursquare2::Client.new(:oauth_token => current_user.foursquare_token)

    # Finds Epoch time for 6 days ago (starting at midnight)
    t = Time.now
    seven_days_ago = t.to_i - 518400 - t.hour * 60 * 60 - t.min * 60 - t.sec

    # Gets checkins in specific category since seven_days_ago
    @checkins = Array.new
    client.user_checkins(:afterTimestamp => seven_days_ago)["items"].map do |item|
      item["venue"]["categories"].map do |category|
        if category.name.include? "Gym" || "Track" || "Yoga" || "Martial Arts"
          count_checkin(item)
        end
      end
      current_user.hashtags.each do |hashtag|
        if item["shout"].to_s.include? '#' + hashtag[:hashtag].to_s
          count_checkin(item)
        end
      end
    end
    @checkins
  end

  def count_checkin(item)
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
    @checkins << checkin
  end

  def get_count
    count = ["Zero", "Once", "Twice", "Three", "Four", "Five", "Six", "Seven"]
    if @checkins.length == 1 || @checkins.length == 2
      "#{count[@checkins.length]}"
    elsif @checkins.length <= 7
      "#{count[@checkins.length]} times"
    else
      "#{@user_checkins.length} times"
    end
  end

end

