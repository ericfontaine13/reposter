class AddContentUrlToTwit < ActiveRecord::Migration[5.0]
  def change
    add_column :twits, :content_url, :string
  end
end
