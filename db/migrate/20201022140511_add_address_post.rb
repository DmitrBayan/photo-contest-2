class AddAddressPost < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :address, :string
    add_column :posts, :longitude, :float
    add_column :posts, :latitude, :float
    add_column :posts, :ip_address, :string
  end
end
