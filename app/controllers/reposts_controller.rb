class RepostsController < ApplicationController
  before_action :find_repost, only: [:show, :edit, :update, :destroy, :get_likes]

  def index
    if params[:filter_by]
      @reposts = Repost.filter(params[:filter_by], params[:min], params[:max], params[:start_at], params[:end_at])
    else
      @reposts = Repost.all.order("created_at DESC")
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

  def get_likes
    # Pour chaque tweet, on recupere le nombre de like du dernier repost
    @reposts_with_publications = Repost.all.select { |t| t.publications.size > 0 }
    @reposts_with_publications.each do |repost|
      new_likes = TWITTER.status(repost.publications.last.link).favorite_count
      current_likes = repost.publications.last.like
      # calcul de la difference entre current_like et new_like
      # pour gerer la possibilité de l'unlike (perte d'un like)
        if new_likes > current_likes
          more_likes = new_likes - current_likes
          repost.publications.last.increment(:like, more_likes).save
          repost.increment(:likes_sum, more_likes).save
          repost.publications.last.increment(:engagement, more_likes).save
          repost.increment(:engagement_sum, more_likes).save
        else
          less_likes = current_likes - new_likes
          repost.publications.last.decrement(:like, less_likes).save
          repost.decrement(:likes_sum, less_likes).save
          repost.publications.last.decrement(:engagement, less_likes).save
          repost.decrement(:engagement_sum, more_likes).save
        end
    end
  end


end
