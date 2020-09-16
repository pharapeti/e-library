class CreateBooks < ActiveRecord::Migration[6.0]
  def change
    create_table :books do |t|
      t.string :title, null: false
      t.string :author, null: false
      t.string :reference_number, null: false
      t.string :edition
      t.integer :book_type, null: false
      t.boolean :active, null: false, default: true

      t.timestamps
    end
  end
end
