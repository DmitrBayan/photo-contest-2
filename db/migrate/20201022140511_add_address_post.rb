class AddAddressPost < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :address, :string, {array: true, default: []}
  end
end
