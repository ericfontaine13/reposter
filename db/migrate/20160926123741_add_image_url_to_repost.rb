class AddImageUrlToRepost < ActiveRecord::Migration[5.0]
  def change
    add_column :reposts, :image_url, :string
  end
end
