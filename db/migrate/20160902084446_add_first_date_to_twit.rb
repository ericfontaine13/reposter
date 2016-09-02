class AddFirstDateToTwit < ActiveRecord::Migration[5.0]
  def change
    add_column :twits, :first_date, :timestamp
  end
end
