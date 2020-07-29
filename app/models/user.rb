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
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  validates :access_token, :uid, :provider, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end
end
