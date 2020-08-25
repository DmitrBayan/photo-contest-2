# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    association :user
    title { Faker::Lorem.word }
    description { Faker::Lorem.sentence }
    photo { "spec/support/posts/post#{Random.rand(1..5)}.jpg" }
    aasm_state { 'approved' }
  end
end
