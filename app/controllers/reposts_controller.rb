class RepostsController < ApplicationController
  before_action :find_repost, only: [:show, :edit, :update, :destroy]

  def index
    if params[:filter_by]
      @reposts = Repost.filter(params[:filter_by], params[:min], params[:max], params[:start_at], params[:end_at])
    else
      @reposts = Repost.all.order("engagement DESC")
    end
  end

  def show
  end

  def new
    @repost = Repost.new
  end

  def create
    Repost.create_repost(params[:twit_id])
    redirect_to reposts_path
  end

  def destroy
    @repost.destroy
    redirect_to reposts_path
  end

  def find_repost
    @repost = Repost.find(params[:id])
  end


end
