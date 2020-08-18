# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    image_url { User.where.not(image_url: nil).order(Arel.sql('RANDOM()')).first }
    provider { 'vkontakte' }
    admin { Faker::Boolean.boolean(true_ratio: 0.1) }
    uid { Faker::Number.number(digits: 10) }
    access_token { Faker::Config.random.seed }
  end
end

def user_with_posts(posts_count)
  FactoryBot.create(:user) do |user|
    FactoryBot.create_list(:post, posts_count, user: user)
  end
end

def user_comment_posts(comments_count)
  FactoryBot.create(:user) do |user|
    FactoryBot.create_list(:comment, comments_count,
                           user: user,
                           post: Post.order(Arel.sql('RANDOM()')).first)
  end
end

def user_comment_comments(comments_count)
  post = Post.where('comments_count > 0').order(Arel.sql('RANDOM()')).first
  FactoryBot.create(:user) do |user|
    FactoryBot.create_list(:comment, comments_count,
                           user: user,
                           post: post,
                           parent_comment: post.comments.first)
  end
end
