# frozen_string_literal: true

ActiveAdmin.register User do
  config.per_page = [5, 10, 50, 100]
  config.clear_action_items!

  permit_params :admin

  filter :full_name_filter, as: :string, label: 'Name'
  filter :aasm_state, as: :select, label: 'State', collection: %w[common banned]
  filter :admin
  filter :count_of_posts, as: :numeric_range_filter

  actions :all, except: %i[edit destroy]

  batch_action :destroy, false

  batch_action :ban do |ids|
    batch_action_collection.find(ids).each do |user|
      user.ban! :ban if user.may_ban?
    end
    redirect_to request.referer
  end

  batch_action :unban do |ids|
    batch_action_collection.find(ids).each do |user|
      user.unban! :unban if user.may_unban?
    end
    redirect_to request.referer
  end

  index do
    selectable_column
    column :id
    column :full_name
    column :avatar do |user|
      image_tag user.avatar.admin.url if user.avatar.present?
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
      link_to admin_posts_path(q: { user_name_filter: user.full_name }) do
        user.count_of_posts == 1 ? "#{user.count_of_posts} post" : "#{user.count_of_posts} posts"
      end
    end
    toggle_bool_column :admin
    actions
  end

  show do
    render 'admin/show_user', layout: 'active_admin', locals: { user: resource }
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
