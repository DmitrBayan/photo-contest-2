class FixDataBaseNameNameColumn < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :image_url, :avatar
  end
end
