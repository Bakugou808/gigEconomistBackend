class Gig < ApplicationRecord
  belongs_to :service
  belongs_to :client
  has_many :appointments, dependent: :destroy
end
