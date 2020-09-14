# frozen_string_literal: true

ActiveAdmin.register Post do
  config.per_page = [5, 10, 50, 100]
  permit_params :title, :description

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
    end
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :description
    end
    f.actions
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
