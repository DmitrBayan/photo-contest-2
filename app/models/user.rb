# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id           :bigint           not null, primary key
#  access_token :string           not null
#  uid          :string           not null
#  first_name   :string
#  last_name    :string
#  image_url    :string
#  url          :string
#  provider     :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  admin        :boolean          default(FALSE)
#  name         :string
#
class User < ApplicationRecord
  include AASM

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_secure_token :authenticity_token

  validates :access_token, :uid, :provider, presence: true

  mount_uploader :image_url, PhotoUploader

  scope :by_first_name, ->(search) { where('first_name ILIKE ?', "%#{search}%") }
  scope :by_last_name, ->(search) { where('last_name ILIKE ?', "%#{search}%") }
  scope :by_full_name, ->(search) { by_first_name(search).or(by_last_name(search)) }

  def full_name
    "#{first_name} #{last_name}"
  end

  def set_authenticity_token
    token = SecureRandom.hex(10)
    if User.find_by(authenticity_token: token)
      set_authenticity_token
    else
      self.update(authenticity_token: token)
    end
  end

  aasm do
    state :common, initial: true
    state :banned

    event :ban do
      transitions to: :banned, from: :common
    end

    event :unban do
      transitions to: :common, from: :banned
    end
  end
end
