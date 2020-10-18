class AddCoordinatesToPost < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :coordinates, :float, array: true, default: []
  end
end
