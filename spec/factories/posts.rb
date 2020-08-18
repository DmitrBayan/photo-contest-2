# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    association :user
    title { Faker::Lorem.word }
    description { Faker::Lorem.sentence }
    photo { Post.order(Arel.sql('RANDOM()')).first.photo }
    aasm_state { 'approved' }
  end
end
