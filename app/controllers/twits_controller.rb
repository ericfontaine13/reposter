class TwitsController < ApplicationController
  before_action :find_twit, only: [:show, :edit, :update, :destroy]

  def index
    if params[:filter_by]
      @twits = Twit.filter(params[:filter_by], params[:min], params[:max], params[:start_at], params[:end_at])
    else
      @twits = Twit.all.order("engagement DESC")
    end
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
