class Repost < ApplicationRecord

  has_many :publications

  def self.create_repost (twits)
    twit = Twit.find_by_id(twits)
    Repost.find_or_create_by(link: twit.link) do |repost|
      repost.twit_id = twit.id
      repost.content = twit.content
      repost.image_url = twit.image_url
      repost.content_url = shortener (twit.content_url)
      repost.click = get_click (repost.content_url)
      repost.like = twit.like
      repost.retweet = twit.retweet
      repost.engagement = twit.engagement
      repost.number_of_publications = repost.publications.count
      repost.likes_sum = twit.like
      repost.retweets_sum = twit.retweet
      repost.sum_engagement = repost.likes_sum + repost.retweets_sum
    end
  end


  def self.shortener (url)
    # On raccourci la content_url pour chaque repost
    # Il faut une short_url unique pour tous les reposts d'un meme twit
    short = `curl -X POST -d "url=#{url}" http://localhost:9393/`
    JSON.load(short)
  end


  def self.get_click (url)
    # on raccourci la content_url pour chaque repost
    # on recupepre le nombre de clics sur la short_url
    shortcode = url.gsub("http://repo.st/", "")
    click = `curl -X GET http://localhost:9393/tracking/#{shortcode}`
    JSON.load(click)
  end


  def self.filter (type = nil, min = nil, max = nil, start_at = nil, end_at = nil)
    a = Repost.all
    a = a.order("#{type}": :desc) if type.present?
    a = a.where(type => min..max) if min.present? && max.present?
    a = a.where(first_date: start_at..end_at) if start_at.present? && end_at.present?
    a
  end


  def self.likes
    # Pour chaque tweet, on recupere le nombre de like du dernier repost
    reposts_with_publications = Repost.all.select { |t| t.publications.size > 0 }
    reposts_with_publications.each do |repost|
      new_likes = TWITTER.status(repost.publications.last.link).favorite_count
      current_likes = repost.publications.last.like
      # calcul de la difference entre current_like et new_like pour ajouter les like
      # uniques au repost initial
        if new_likes > current_likes
          real_likes = new_likes - current_likes
          repost.publications.last.increment(:like, real_likes).save
          repost.publications.last.increment(:engagement, real_likes).save
        else
          nil
        end
      # On update la colonne like du dernier repost dans la base
      repost.publications.last.update(like: new_likes)
      # On calcule la somme de tous les likes pour chaque tweet
      likes_sum = repost.publications.sum { |publication| publication.like }
      repost.increment(:likes_sum, likes_sum).save
      repost.increment(:sum_engagement, likes_sum).save
    end
  end


  def self.retweets
    # Pour chaque tweet, on recupere le nombre de retweet du dernier repost
    tweets_with_repost = Twit.all.select { |t| t.reposts.size > 0 }
    tweets_with_repost.each do |twit|
      new_retweets = TWITTER.status(twit.reposts.last.link).retweet_count
      current_retweets = twit.reposts.last.retweet
      # calcul de la difference entre current_retweets et new_retweets pour ajouter les retweets
      # uniques au twit initial
      if new_retweets > current_retweets
        real_retweets = new_retweets - current_retweets
        twit.increment(:retweet, real_retweets).save
      else
        nil
      end
      # On update la colonne retweet du dernier repost dans la base
      twit.reposts.last.update(retweet: new_retweets)
      # On calcule la somme de tous les retweets pour chaque tweet
      twit.reposts.sum { |repost| repost.retweet }
    end
  end


  def number_of_publications_by_repost
    # Savoir combien de fois un tweet a été reposté
    tweets_with_repost = Twit.all.select { |t| t.reposts.size > 0 }
    tweets_with_repost.each do |twit|
      number_of_reposts = twit.reposts.size
      puts "The tweet #{twit.id} has #{number_of_reposts}"
    end
  end

end

