require 'faker'

FactoryBot.define do
  factory :user do
    first_name   { Faker::Name.first_name }
    last_name    { Faker::Name.last_name }
    image_url    { Faker::Avatar.image }
    provider     { 'vkontakte' }
    admin        { Faker::Boolean.boolean(true_ratio: 0.1) }
    uid          { Faker::Number.number(digits: 10) }
    access_token { Faker::Config.random.seed }
  end
end