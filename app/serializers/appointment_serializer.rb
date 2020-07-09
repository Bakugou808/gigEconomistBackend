class AppointmentSerializer < ActiveModel::Serializer
  attributes :id, :title, :date_of_appointment, :payment_amount, :time_of_appointment, :notes, :location, :end_of_appointment, :created_at, :completed
  belongs_to :gig
end
