class CreateLoans < ActiveRecord::Migration[6.0]
  def change
    create_table :loans do |t|
      t.references :user, null: false, foreign_key: true
      t.references :book, null: false, foreign_key: true
      t.datetime :borrowed_at, null: false
      t.datetime :returned_at
      t.datetime :renewed_at

      t.timestamps
    end
  end
end
