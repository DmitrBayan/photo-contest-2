class SomeFixesForParentComment < ActiveRecord::Migration[6.0]
  def change
  	remove_column :comments, :parent_comment_id
  	add_column :comments, :parent_comment_id, :integer, index: true, foreign_key: true
  end
end
