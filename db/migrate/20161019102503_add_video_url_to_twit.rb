class AddVideoUrlToTwit < ActiveRecord::Migration[5.0]
  def change
    add_column :twits, :video_url, :string
  end
end
