class ChangeDurationToEndOfAppointmentInAppointments < ActiveRecord::Migration[6.0]
  def change
    remove_column :appointments, :duration, :string
    add_column :appointments, :end_of_appointment, :time
    remove_column :appointments, :time_of_appointment, :string 
    add_column :appointments, :time_of_appointment, :time
    remove_column :appointments, :date_of_appointment, :string
    add_column :appointments, :date_of_appointment, :date
  end
end
