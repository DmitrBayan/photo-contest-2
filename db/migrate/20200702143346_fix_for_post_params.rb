class FixForPostParams < ActiveRecord::Migration[6.0]
  def change
  	remove_column :posts, :title
  	add_column :posts, :description, :text
  	add_column :posts, :title, :string
  end
end
