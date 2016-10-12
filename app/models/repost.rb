class Repost < ApplicationRecord

  def self.create_repost(twits)
    #checked_twits.each do |twits|
      twit = Twit.find_by_id(twits)
      Repost.find_or_create_by(link: twit.link) do |repost|
        repost.content = twit.content
        repost.like = twit.like
        repost.retweet = twit.retweet
        repost.engagement = twit.engagement
        repost.content_url = twit.content_url #Voir Bitly
        repost.image_url = twit.image_url
        repost.first_date = twit.first_date
      end
    #end
  end

  def self.filter(type = nil, min = nil, max = nil, start_at = nil, end_at = nil)
    a = Repost.all
    a = a.order("#{type}": :desc) if type.present?
    a = a.where(type => min..max) if min.present? && max.present?
    a = a.where(first_date: start_at..end_at) if start_at.present? && end_at.present?
    a
  end

end
