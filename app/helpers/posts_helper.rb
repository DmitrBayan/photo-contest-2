# frozen_string_literal: true

module PostsHelper
  class VkPhotoCollection
    def get_vk_collection(user)
      collection = []
      vk = VkontakteApi::Client.new(user.access_token)
      temp = vk.photos.get_all({ count: 8,
                                 owner_id: user.uid,
                                 v: 5.21 })
      temp.items.each do |item|
        item = item.select { |k, v| k.start_with?('photo') }
                   .map { |k, v| { k.split('_').last.to_i => v } }
                   .map(&:to_a)
                   .map(&:flatten)
                   .max_by { |x| x[0] }
                   .last
        collection.append(item)
      end
      collection
    end
  end
  class Share
    def share_link(post, url)
      'http://vk.com/share.php?url=' + url + '&image=' + post.photo.url + '&title=' + post.title
    end
  end
end
