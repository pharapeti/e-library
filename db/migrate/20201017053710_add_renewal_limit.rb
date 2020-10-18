class AddRenewalLimit < ActiveRecord::Migration[6.0]
  def change
    remove_column :books, :max_renewal
    remove_column :loans, :renewal_no
    add_column :books, :max_renewal, :integer if !column_exists?(:books, "max_renewal")
    add_column :loans, :renewal_no, :integer, :default => 0 if !column_exists?(:books, "renewal_no")
  end
end
