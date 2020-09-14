# frozen_string_literal: true

ActiveAdmin.register User do
  config.per_page = [5, 10, 50, 100]

  index do
    selectable_column
    column :id
    column :name do |user|
      user.full_name
    end
    column :avatar do |user|
      image_tag user.image_url.admin.url if user.image_url.present?
    end
    tag_column :aasm_state
    column :moderation do |user|
      columns do
        if user.common?
          column do
            link_to :ban, ban_admin_user_path(user), class: 'button1'
          end
        else
          column do
            link_to :unban, unban_admin_user_path(user), class: 'button2'
          end
        end
      end
    end
    column :count_of_posts do |user|
      user.posts.size
    end
    actions
  end

  show do
    attributes_table do
      row :avatar do |user|
        image_tag user.image_url.show.url if user.image_url.present?
      end
      row :first_name
      row :last_name
      row :link do
        link_to user.full_name, user
      end
      row :email
      row :admin
      row :created_at
      row :updated_at
      row :id
      tag_row :aasm_state
    end
  end

  member_action :ban do
    resource.ban!
    UserMailer.state_change_email(resource).deliver_now
    redirect_to admin_users_path
  end

  member_action :unban do
    resource.unban!
    UserMailer.state_change_email(resource).deliver_now
    redirect_to admin_users_path
  end

end