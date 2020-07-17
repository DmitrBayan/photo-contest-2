# frozen_string_literal: true

# == Schema Information
#
# Table name: comments
#
#  id                :bigint           not null, primary key
#  body              :text
#  user_id           :bigint           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  post_id           :integer
#  parent_comment_id :integer
#
class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post, counter_cache: :comments_count

  has_many :replies,
           class_name: 'Comment',
           dependent: :destroy,
           foreign_key: 'parent_comment_id',
           inverse_of: :parent_comment

  belongs_to :parent_comment,
             class_name: 'Comment',
             optional: true,
             inverse_of: :replies

  validates :body, presence: true, length: { minimum: 1 }
end
