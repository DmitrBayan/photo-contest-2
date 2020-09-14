# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/post_mailer
class PostMailerPreview < ActionMailer::Preview
  def state_change_email
    @post = Post.first
    PostMailer.state_change_email(@post)
  end
end
