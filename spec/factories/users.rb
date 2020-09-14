# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    image_url { File.open('spec/support/users/user_default.png') }
    provider { 'vkontakte' }
    admin { Faker::Boolean.boolean(true_ratio: 0.1) }
    uid { Faker::Number.number(digits: 10) }
    access_token { Faker::Config.random.seed }

    trait(:with_posts_with_likes) do
      after(:create) do |user|
        user_with_posts = create(:user)
        posts = create_list(:post, 5, user: user_with_posts)
        posts_with_likes = []
        3.times { posts_with_likes << posts.sample }
        posts_with_likes = posts_with_likes.uniq
        posts_with_likes.each do |post|
          create(:like, post: post, user: user)
        end
      end
    end

    trait(:with_posts) do
      after(:create) do |user|
        create_list(:post, 5, user: user)
      end
    end

    trait(:comment_posts) do
      after(:create) do |user|
        create_list(:comment, 2,
                    user: user,
                    post: Post.order(Arel.sql('RANDOM()')).first)
      end
    end

    trait(:comment_comment) do
      after(:create) do |user|
        post = Post.where('comments_count > 0').order(Arel.sql('RANDOM()')).first
        create_list(:comment, 2,
                    user: user,
                    post: post,
                    parent_comment: post.comments.first)
      end
    end

    factory :user_with_posts_with_likes do
      with_posts_with_likes
    end

    factory :user_with_posts do
      with_posts
    end

    factory :user_comment_posts do
      comment_posts
    end

    factory :user_comment_comment do
      comment_comment
    end
  end
end
