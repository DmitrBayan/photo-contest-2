class RemoveCommentableFromComment < ActiveRecord::Migration[6.0]
  def change
  	remove_column :comments, :commentable_id
  	remove_column :comments, :commentable_type
  end
end
