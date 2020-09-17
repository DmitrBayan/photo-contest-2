# frozen_string_literal: true

ActiveAdmin.register User, as: 'Admins' do
  config.per_page = [5, 10, 50, 100]
  config.clear_action_items!

  permit_params :admin

  actions :all, except: %i[edit destroy]

  filter :full_name_filter, as: :string, label: 'Name'

  controller do
    def scoped_collection
      super.where(admin: true)
    end
  end

  index do
    selectable_column
    id_column
    column :full_name
    column :avatar do |user|
      image_tag user.image_url.admin.url if user.image_url.present?
    end
    toggle_bool_column :admin
    actions
  end

  show do
    render 'admin/show_user', layout: 'active_admin', locals: { user: resource }
  end
end
