# frozen_string_literal: true

ActiveAdmin.register Post do
  config.per_page = [5, 10, 50, 100]
  config.clear_action_items!

  filter :aasm_state, as: :select, label: 'State', collection: ['moderated', 'approved', 'banned']
  filter :likes_count, as: :numeric_range_filter
  filter :comments_count, as: :numeric_range_filter
  filter :user_name_filter, as: :string, label: 'Author name'

  controller do
    def show
      @comments = resource.comments
    end
  end

  batch_action I18n.t(:ban) do |ids|
    batch_action_collection.find(ids).each do |post|
      post.ban! :ban if post.may_banned?
    end
    redirect_to admin_posts_path
  end

  batch_action I18n.t(:approve) do |ids|
    batch_action_collection.find(ids).each do |post|
      post.approve! :approve if post.may_approved?
    end
    redirect_to admin_posts_path
  end

  batch_action :destroy, false

  index do
    selectable_column
    column :id
    column :author do |post|
      link_to post.user.full_name,
              admin_posts_path(q: {user_name_filter: post.user.full_name})
    end
    column :title
    column :photo do |post|
      image_tag post.photo.admin.url
    end
    tag_column :aasm_state
    column :moderation do |post|
      columns do
        if post.moderated?
          column do
            link_to :approve, approve_admin_post_path(post), class: 'button2'
          end
          column do
            link_to :ban, ban_admin_post_path(post), class: 'button1'
          end
        elsif post.banned?
          column do
            link_to :restore, restore_admin_post_path(post), class: 'button1'
          end
        else
          column do
            'ALREADY APPROVED (ᵔᴥᵔ)'
          end
        end
      end
    end
    actions
  end

  show do
    attributes_table do
      row :photo do |post|
        image_tag post.photo.show.url
      end
      row :title
      row :description
      row :author, :user_id do
        link_to(post.user.full_name, post.user)
      end
      row :created_at
      row :updated_at
      row :id
      tag_row :aasm_state
      row :comments do
        render 'admin/comments_show_post',
               collection: resource.comments.where({parent_comment_id: nil}) if resource.comments.present?
      end
    end
  end

  member_action :approve do
    resource.approve!
    PostMailer.state_change_email(resource).deliver_now
    redirect_to admin_posts_path
  end

  member_action :ban do
    resource.ban!
    BanPostWorker.perform_in(5.minutes, resource.id)
    PostMailer.state_change_email(resource).deliver_now
    redirect_to admin_posts_path, notice: 'You have 5 minutes to restore this if you want.'
  end

  member_action :restore do
    resource.restore!
    redirect_to admin_posts_path
  end
end
