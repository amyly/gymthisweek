class WelcomeController < ApplicationController
  def index
    if current_user
      @user = current_user
      @user_checkins = current_user.get_checkins(current_user)
      @hashtag = current_user.hashtags.build
      @user_checkins_count = current_user.get_count
    end
  end
end
