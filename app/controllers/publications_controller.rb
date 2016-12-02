class PublicationsController < ApplicationController

  def index
    @publications = Publication.all.order("created_at DESC")
  end

  def create
    Publication.publish(params[:repost_id])
    redirect_to publications_path
  end

end
