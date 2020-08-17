FactoryBot.define do
  factory :post do
    association :user
    title { Faker::Lorem.word }
    description { Faker::Lorem.sentence }
    photo { Post.order(Arel.sql('RANDOM()')).first.photo }
    aasm_state { 'approved' }
    likes_count {Faker::Number.between(from: 2, to: 10)}
  end
end