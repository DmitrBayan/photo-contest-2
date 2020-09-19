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
  include PhotoValidator

  belongs_to :user, counter_cache: :count_of_posts

  mount_uploader :photo, PhotoUploader

  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  validates :title, :photo, presence: true

  scope :by_title, ->(search) { approved.where('title ILIKE ?', "%#{search}%") }
  scope :by_description, ->(search) { approved.where('description ILIKE ?', "%#{search}%") }
  scope :by_title_or_description, ->(search) { by_title(search).or(by_description(search)) }
  scope :by_user_full_name, ->(search) { approved.where(user_id: User.by_full_name(search).pluck(:id)) }

  def self.user_name_filter(search)
    by_user_full_name(search)
  end

  def self.ransackable_scopes(_auth_object = nil)
    %i[user_name_filter]
  end

  aasm do
    state :moderated, initial: true
    state :approved
    state :banned

    event :approve do
      transitions to: :approved, from: :moderated
    end

    event :ban do
      transitions to: :banned, from: :moderated
    end

    event :restore do
      transitions to: :moderated, from: :banned
    end
  end
end
