class ChangeNotesInAppointmentsToMediumText < ActiveRecord::Migration[6.0]
  def change
    change_column :appointments, :notes, :text, limit: 16.megabytes - 1

  end
end
