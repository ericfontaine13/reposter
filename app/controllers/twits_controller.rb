class TwitsController < ApplicationController

  def index
    if params[:filter] && params[:order]
      @twits = Twit.order_by(params[:filter], params[:order])
    else
      @twits = Twit.all
    end
  end

end
