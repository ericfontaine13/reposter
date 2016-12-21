class Publication < ApplicationRecord

  belongs_to :repost

  def self.publish (reposts)
      repost = Repost.find_by_id(reposts)
      Publication.create do |publication|
        publication.repost_id = repost.id
        publication.content = repost.content
        publication.image_url = repost.image_url
        publication.content_url = shortener(repost.content_url)
        publication.click = 0
        publication.like = 0
        publication.retweet = 0
        publication.engagement = 0
        publication.link = TWITTER.update_with_media("#{repost.content}#{publication.content_url}", open("#{repost.image_url}")).uri
      end
  end


  def self.shortener (url)
    # On raccourci la content_url pour chaque repost
    # Il faut une short_url unique pour tous les reposts d'un meme twit
    short = `curl -X POST -d "url=#{url}" http://localhost:9393/`
    JSON.load(short)
  end

end
