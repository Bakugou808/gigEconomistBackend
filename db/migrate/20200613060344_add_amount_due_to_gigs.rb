class AddAmountDueToGigs < ActiveRecord::Migration[6.0]
  def change
    add_column :gigs, :amount_due, :float
  end
end
