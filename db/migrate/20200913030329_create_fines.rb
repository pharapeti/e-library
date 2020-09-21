class CreateFines < ActiveRecord::Migration[6.0]
  def change
    create_table :fines do |t|
      t.references :loan, null: false, foreign_key: true
      t.datetime :charged_at
      t.float :amount, null: false

      t.timestamps
    end
  end
end
