# frozen_string_literal: true

# == Schema Information
#
# Table name: posts
#
#  id             :bigint           not null, primary key
#  user_id        :bigint           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  photo          :string
#  aasm_state     :string
#  likes_count    :integer          default(0), not null
#  comments_count :integer          default(0), not null
#  description    :text
#  title          :string
#
class Post < ApplicationRecord
  include AASM

  belongs_to :user

  mount_uploader :photo, PhotoUploader

  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  validates :title, :photo, presence: true
  validate :photo_size

  scope :by_title, ->(search) { approved.where("title ILIKE ?","%#{search}%") }
  scope :by_description, ->(search) { approved.where("description ILIKE ?","%#{search}%") }
  scope :by_title_or_description, ->(search) { by_title(search).or(by_description(search)) }
  scope :by_user_full_name, ->(search) { approved.where(user_id: User.by_full_name(search).pluck(:id)) }
  scope :by_state, ->(filter) { where("aasm_state = ?", "#{filter}") }

  aasm do
    state :moderated, initial: true
    state :approved
    state :banned
    state :deleted
    event :approve do
      transitions to: :approved, from: %i[moderated banned]
    end

    event :ban do
      transitions to: :banned, from: %i[moderated approved]
    end

    event :delete do
      transitions to: :deleted, from: %i[moderated approved banned]
    end

    event :restore do
      transitions from: :deleted, to: :moderated
    end
  end

  def photo_size
    errors.add(:photo, 'should be less than 5MB') if photo.size >= 5.megabytes
  end
end
