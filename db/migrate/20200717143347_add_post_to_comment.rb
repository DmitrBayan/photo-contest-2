class AddPostToComment < ActiveRecord::Migration[6.0]
  def change
  	add_column :comments, :post_id, :integer
  	add_column :comments, :parent_comment_id, :integer
  end
end
