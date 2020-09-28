class AddBookDescriptionAndBorrowLimit < ActiveRecord::Migration[6.0]
  def change
    add_column :books, :description, :text if !column_exists?(:books, "description")
    add_column :books, :amount, :integer if !column_exists?(:books, "amount")
  end
end
