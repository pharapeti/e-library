class RenameTypeToAccountTypeOnUsers < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :type, :account_type
  end
end
