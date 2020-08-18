# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    association :user
    association :post
    body { Faker::Lorem.sentence }
  end
end
