class AddImageUrlToTwit < ActiveRecord::Migration[5.0]
  def change
    add_column :twits, :image_url, :string
  end
end
