class Publication < ApplicationRecord

  belongs_to :repost

  def self.publish (reposts)
      repost = Repost.find_by_id(reposts)
      Publication.create do |publication|
        publication.repost_id = repost.id
        publication.content = repost.content
        publication.image_url = repost.image_url
        publication.content_url = repost.content_url
        publication.click = get_click (repost.content_url)
        publication.like = 0
        #repost.new_like
        #repost.new_retweet
        #repost.new_engagment = repost.new_like + repost.new_retweet
        publication.retweet = 0
        publication.engagement = publication.like + publication.retweet
        publication.link = TWITTER.update_with_media("#{repost.content}#{repost.content_url}", open("#{repost.image_url}")).uri
      end
  end


  def self.get_click (url)
    # on raccourci la content_url pour chaque repost
    # on recupepre le nombre de clics sur la short_url
    shortcode = url.gsub("http://repo.st/", "")
    click = `curl -X GET http://localhost:9393/tracking/#{shortcode}`
    JSON.load(click)
  end






    # def sum_of_likes
    #   # On calcule la somme de tous les likes pour chaque tweet
    #   tweets_with_repost = Twit.all.select { |t| t.reposts.size > 0 }
    #   tweets_with_repost.each do |twit|
    #     twit.reposts.sum { |repost| repost.like }
    #   end
    # end


    # def sum_of_retweets
    #   # On calcule la somme de tous les retweets pour chaque tweet
    #   tweets_with_repost = Twit.all.select { |t| t.reposts.size > 0 }
    #   tweets_with_repost.each do |twit|
    #     twit.reposts.sum { |repost| repost.retweet }
    #   end
    # end


  def sum_of_engagement
    sum_of_likes + sum_of_retweets
  end


    def self.repost



      # Selon la fréquence choisie (CRON) :
      # on appelle la methode likes
      # on appelle la méthode retweets



      # appeler la methode selon le calendrier (CRON) ou manuellement
      # recuperer le link Twitter du dernier repost
      # => twit.reposts.last.link

      # recuperer new_like
      # => self.get_new_like
      # Mettre à jour repost_sum_like

      # recuprer new_retweet
      # => self.get_new_retweet
      # Mettre à jour repost_sum_retweet

      # creer le new repost et updater repost.link avec le link du nouveau tweet
      # => repost.link = TWITTER.update_with_media("#{repost.content}#{repost.content_url}", open("#{repost.image_url}")).uri

      # updater nombre de repost
      # => twit.reposts.count

    end





end
