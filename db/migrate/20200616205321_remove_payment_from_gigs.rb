class RemovePaymentFromGigs < ActiveRecord::Migration[6.0]
  def change
    remove_column :gigs, :amount_due, :float
  end
end
