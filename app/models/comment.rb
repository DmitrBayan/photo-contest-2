# frozen_string_literal: true

# == Schema Information
#
# Table name: comments
#
#  id               :bigint           not null, primary key
#  body             :text
#  commentable_type :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  comment_id       :bigint
#  commentable_id   :integer
#  user_id          :bigint           not null
#
# Indexes
#
#  index_comments_on_comment_id  (comment_id)
#  index_comments_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (comment_id => comments.id)
#  fk_rails_...  (user_id => users.id)
#
class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post, counter_cache: :comments_count

  has_many :replies,
           class_name: 'Comment',
           foreign_key: 'parent_comment_id',
           dependent: :destroy,
           inverse_of: :comment

  belongs_to :parent_comment,
             class_name: 'Comment',
             optional: true,
             inverse_of: :comments

  validates :body, presence: true, length: { minimum: 1 }
end
