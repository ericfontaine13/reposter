class Repost < ApplicationRecord

  has_many :publications

  def self.create_repost (twits)
    twit = Twit.find_by_id(twits)
    Repost.find_or_create_by(link: twit.link) do |repost|
      repost.twit_id = twit.id
      repost.content = twit.content
      repost.image_url = twit.image_url
      repost.content_url = twit.content_url
      repost.click = 0
      repost.like = 0
      repost.retweet = 0
      repost.engagement = 0
      repost.number_of_publications = repost.publications.count
      repost.likes_sum = 0
      repost.retweets_sum = 0
      repost.engagement_sum = 0
    end
  end


  def self.filter (type = nil, min = nil, max = nil, start_at = nil, end_at = nil)
    a = Repost.all
    a = a.order("#{type}": :desc) if type.present?
    a = a.where(type => min..max) if min.present? && max.present?
    a = a.where(first_date: start_at..end_at) if start_at.present? && end_at.present?
    a
  end



###### LIKES CLASS METHOD ######

  # def self.likes
  #   # Pour chaque tweet, on recupere le nombre de like du dernier repost
  #   reposts_with_publications = Repost.all.select { |t| t.publications.size > 0 }
  #   reposts_with_publications.each do |repost|
  #     new_likes = TWITTER.status(repost.publications.last.link).favorite_count
  #     current_likes = repost.publications.last.like
  #     # calcul de la difference entre current_like et new_like
  #     # pour gerer la possibilité de l'unlike (perte d'un like)
  #     if new_likes > current_likes
  #       more_likes = new_likes - current_likes
  #       repost.publications.last.increment(:like, more_likes).save
  #       repost.increment(:likes_sum, more_likes).save
  #       repost.publications.last.increment(:engagement, more_likes).save
  #       repost.increment(:engagement_sum, more_likes).save
  #     else
  #       less_likes = current_likes - new_likes
  #       repost.publications.last.decrement(:like, less_likes).save
  #       repost.decrement(:likes_sum, less_likes).save
  #       repost.publications.last.decrement(:engagement, less_likes).save
  #       repost.decrement(:engagement_sum, more_likes).save
  #     end
  #   end
  # end


###### LIKES INSTANCE METHOD ######

  def get_new_likes
    new_likes = TWITTER.status(publications.last.link).favorite_count
    current_likes = publications.last.like
    if new_likes > current_likes
      more_likes = new_likes - current_likes
      publications.last.increment(:like, more_likes).save
      publications.last.increment(:engagement, more_likes).save
      increment(:likes_sum, more_likes).save
      increment(:engagement_sum, more_likes).save
    elsif current_likes > new_likes
      less_likes = current_likes - new_likes
      publications.last.decrement(:like, less_likes).save
      publications.last.decrement(:engagement, less_likes).save
      decrement(:likes_sum, less_likes).save
      decrement(:engagement_sum, less_likes).save
    else
      nil
    end
  end


###### RETWEETS CLASS METHOD ######

  # def self.retweets
  #   # Pour chaque tweet, on recupere le nombre de retweet du dernier repost
  #   reposts_with_publications = Repost.all.select { |t| t.publications.size > 0 }
  #   reposts_with_publications.each do |repost|
  #     new_retweets = TWITTER.status(repost.publications.last.link).retweet_count
  #     current_retweets = repost.publications.last.retweet
  #     # calcul de la difference entre current_retweets et new_retweets pour ajouter les retweets
  #     # uniques au twit initial
  #     if new_retweets > current_retweets
  #       real_retweets = new_retweets - current_retweets
  #       repost.increment(:retweet, real_retweets).save
  #       repost.publications.last.increment(:engagement, real_likes).save
  #     else
  #       nil
  #     end
  #     # On update la colonne retweet du dernier repost dans la base
  #     repost.publications.last.update(retweet: new_retweets)
  #     # On fait la somme de tous les retweets de toutes les publications
  #     retweets_sum = repost.publications.sum { |publication| publication.retweet }
  #     # On incremente le total des retweets et engagements du repost
  #     repost.increment(:retweets_sum, retweets_sum).save # real_retweets or new_retweets?
  #     repost.increment(:sum_engagement, retweets_sum).save # real_retweets or new_retweets?
  #   end
  # end


###### RETWEETS INSTANCE METHOD ######

  def get_new_retweets
    new_retweets = TWITTER.status(publications.last.link).retweet_count
    current_retweets = publications.last.retweet
    if new_retweets > current_retweets
      more_retweets = new_retweets - current_retweets
      publications.last.increment(:retweet, more_retweets).save
      publications.last.increment(:engagement, more_retweets).save
      increment(:retweets_sum, more_retweets).save
      increment(:engagement_sum, more_retweets).save
    elsif current_retweets > new_retweets
      less_retweets = current_retweets - new_retweets
      publications.last.decrement(:retweet, less_retweets).save
      publications.last.decrement(:engagement, less_retweets).save
      decrement(:retweets_sum, less_retweets).save
      decrement(:engagement_sum, less_retweets).save
    else
      nil
    end
  end


###### CLICKS CLASS METHOD ######

  # def self.clicks
  #   # Pour chaque tweet, on recupere le nombre de retweet du dernier repost
  #   reposts_with_publications = Repost.all.select { |t| t.publications.size > 0 }
  #   reposts_with_publications.each do |repost|
  #     shortcode = repost.publications.last.content_url.gsub("http://repo.st/", "")
  #     new_clicks = `curl -X GET http://localhost:9393/tracking/#{shortcode}`
  #     clicks = JSON.load(new_clicks)
  #     repost.publications.last.update(click: clicks)
  #     clicks_sum = repost.publications.sum { |publication| publication.click }
  #     repost.increment(:click, clicks_sum).save
  #   end
  # end


###### CLICKS INSTANCE METHOD ######

  def get_new_clicks
    shortcode = publications.last.content_url.gsub("http://repo.st/", "")
    clicks = `curl -X GET https://myshortenr.herokuapp.com/tracking/#{shortcode}`
    new_clicks = JSON.load(clicks).to_i
    current_clicks = publications.last.click
    if new_clicks > current_clicks
      more_clicks = new_clicks - current_clicks
      publications.last.increment(:click, more_clicks).save
      increment(:click, more_clicks).save
    else
      nil
    end
  end


###### GLOBAL REPOST UPDATE INSTANCE METHOD ######

  def get_data
    get_new_likes
    get_new_retweets
    get_new_clicks
  end





end

