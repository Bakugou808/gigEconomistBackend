class ChangeDetailsInGigsToMediumText < ActiveRecord::Migration[6.0]
  def change
    change_column :gigs, :details, :text, limit: 16.megabytes - 1

  end
end
