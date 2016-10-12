class AddContentUrlToRepost < ActiveRecord::Migration[5.0]
  def change
    add_column :reposts, :content_url, :string
  end
end
