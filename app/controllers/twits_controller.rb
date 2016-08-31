class TwitsController < ApplicationController

  def index
    if params[:filter] == "like"
      @twits = Twit.most_liked
    elsif params[:filter] == "retweet"
      @twits = Twit.most_retweeted
    else
      @twits = Twit.all
    end
  end

end
