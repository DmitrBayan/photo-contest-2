# frozen_string_literal: true

module PostsHelper
  class Share
    def sharing(post, url)
      'http://vk.com/share.php?url=' + url + '&image=' + post.photo.url + '&title=' + post.title
    end
  end
end
