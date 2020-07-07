# frozen_string_literal: true

# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  aasm_state :string
#  photo      :string
#  title      :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_posts_on_user_id                 (user_id)
#  index_posts_on_user_id_and_created_at  (user_id,created_at)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Post < ApplicationRecord
  include AASM

  belongs_to :user
  mount_uploader :photo, PhotoUploader

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes, dependent: :destroy

  validates :title, :photo, presence: true
  validate :photo_size

  aasm do
    state :moderated, initial: true
    state :approved
    state :banned
    state :deleted
    event :approve do
      transitions to: :approved, from: [:moderated, :banned]
    end

    event :ban do
      transitions to: :banned, from: [:moderated, :approved]
    end

    event :delete do
      transitions to: :deleted, from: [:moderated, :approved, :banned]
    end

    event :restore do
      transitions from: :deleted, to: :moderated
    end

  end

  def photo_size
    errors.add(:photo, 'should be less than 5MB') if photo.size >= 5.megabytes
  end
end
