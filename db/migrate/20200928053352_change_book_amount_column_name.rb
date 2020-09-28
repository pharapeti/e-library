class ChangeBookAmountColumnName < ActiveRecord::Migration[6.0]
  def change
    rename_column :books, :amount, "max_copies"
  end
end
