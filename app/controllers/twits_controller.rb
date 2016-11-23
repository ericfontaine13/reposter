class TwitsController < ApplicationController
  before_action :find_twit, only: [:show, :edit, :update, :destroy]

  def index
    if params[:filter_by]
      @twits = Twit.filter(params[:filter_by], params[:min], params[:max], params[:start_at], params[:end_at], params[:media])
    else
      @twits = Twit.all.order("first_date DESC")
    end
  end

  def create
    Twit.get_tweets(params[:twitter_user])
    redirect_to twits_path
  end

  def show
  end

  def destroy
    @twit.destroy
    redirect_to twits_path
  end

  def find_twit
    @twit = Twit.find(params[:id])
  end

end
