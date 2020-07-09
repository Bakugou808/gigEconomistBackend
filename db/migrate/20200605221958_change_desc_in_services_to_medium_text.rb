class ChangeDescInServicesToMediumText < ActiveRecord::Migration[6.0]
  def change
    change_column :services, :description, :text, limit: 16.megabytes - 1

  end
end
