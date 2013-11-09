class WelcomeController < ApplicationController
  def index
    if current_user
      @user = current_user
      @user_checkins = current_user.get_checkins(current_user)
    end
  end
end
