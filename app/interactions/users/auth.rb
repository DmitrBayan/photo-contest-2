# frozen_string_literal: true

module Users
  class Auth < ActiveInteraction::Base
    hash :auth_hash, strip: false
    def execute
      case auth_hash['provider']
      when 'vkontakte'
        from_vk
      when 'facebook'
        from_fb
      else
        user.errors.add(:base, 'Unknown provider')
      end
      user.save ? user : user.errors
    end

    private

    def user
      @user ||= ::User.find_or_create_by(uid: auth_hash['uid'],
                                         provider: auth_hash['provider'])
    end

    def from_vk
      user.first_name = auth_hash['info']['first_name'] if user.first_name.blank?
      user.last_name = auth_hash['info']['last_name'] if user.last_name.blank?
      user.image_url = auth_hash['info']['image'] if user.image_url.blank?
      user.url = auth_hash['info']['urls']['Vkontakte']
      user.access_token = auth_hash['credentials']['token']
    end

    def from_fb
      first_name, last_name = auth_hash['info']['name'].split(' ')
      user.first_name = first_name if user.first_name.blank?
      user.last_name = last_name if user.last_name.blank?
      user.image_url = auth_hash['info']['image'] if user.image_url.blank?
      user.access_token = auth_hash['credentials']['token']
    end
  end
end
