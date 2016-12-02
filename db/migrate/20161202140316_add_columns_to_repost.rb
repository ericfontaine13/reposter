class AddColumnsToRepost < ActiveRecord::Migration[5.0]
  def change
    add_column :reposts, :number_of_publications, :integer
    add_column :reposts, :likes_sum, :integer
    add_column :reposts, :retweets_sum, :integer
    add_column :reposts, :sum_engagement, :integer
  end
end
