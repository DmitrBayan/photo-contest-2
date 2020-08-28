class AddAuthenticateTokenToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :authenticity_token, :string
    add_index :users, :authenticity_token, unique: true
  end
end
