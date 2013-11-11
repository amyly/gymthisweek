class HashtagsController < ApplicationController

  def index
  end

  def new
    @hashtag = Hashtag.new
  end

  def create
    @hashtag = current_user.hashtags.build(hashtag_params)
    if @hashtag.save
      redirect_to root_url, notice: "Hashtag added!"
    else
      redirect_to root_url, notice: "Hashtag not added :("
    end
  end

  def destroy
    @hashtag = Hashtag.find(params[:id])
    if @hashtag.destroy
      redirect_to root_url
      flash[:success] = "Hashtag destroyed"
    else
      redirect_to root_url, notice: "Hashtag not destroyed"
    end
  ends

private
  def hashtag_params
    params.require(:hashtag).permit(:hashtag)
  end

end
