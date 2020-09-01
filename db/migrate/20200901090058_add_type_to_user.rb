class AddTypeToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :type, :integer, null: false
  end
end
