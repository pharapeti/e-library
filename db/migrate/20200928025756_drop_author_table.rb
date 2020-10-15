class DropAuthorTable < ActiveRecord::Migration[6.0]
  def change
    drop_table :authors if table_exists?(:authors)
    drop_table :book_authors if table_exists?(:book_authors)
  end
end
