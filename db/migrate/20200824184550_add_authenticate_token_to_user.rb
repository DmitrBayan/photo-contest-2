class AddAuthenticateTokenToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :authenticate_token, :string
    add_index :users, :authenticate_token, unique: true
  end
end
