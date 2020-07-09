class CreateAppointments < ActiveRecord::Migration[6.0]
  def change
    create_table :appointments do |t|
      t.string :title
      t.string :date_of_appointment
      t.string :payment_amount
      t.string :time_of_appointment
      t.text :notes
      t.string :location
      t.string :duration
      t.references :gig, null: false, foreign_key: true

      t.timestamps
    end
  end
end
