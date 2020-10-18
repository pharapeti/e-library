class CreateBookRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :book_requests do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.string :author
      t.integer :edition
      t.boolean :fulfillment, :default => false
    end
  end
end
