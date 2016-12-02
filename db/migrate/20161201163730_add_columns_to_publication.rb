class AddColumnsToPublication < ActiveRecord::Migration[5.0]
  def change
    add_column :publications, :repost_id, :integer
    add_column :publications, :content_url, :string
    add_column :publications, :image_url, :string
    add_column :publications, :first_date, :datetime
    add_column :publications, :click, :integer
  end
end
