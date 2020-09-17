class AddUserCountOfPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :count_of_posts, :integer, null: false, default: 0
  end
end
