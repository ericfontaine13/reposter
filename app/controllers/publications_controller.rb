class PublicationsController < ApplicationController
  before_action :find_publication, only: [:show, :edit, :update, :destroy]

  def index
    @publications = Repost.find(params[:repost_id]).publications.order("created_at DESC")
  end

  def create
    Publication.publish(params[:repost_id])
    redirect_to reposts_path
  end

  def show
  end

  def find_publication
    @publication = Publication.find(params[:id])
  end


end
