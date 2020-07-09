class ServiceSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :pay_range, :gigs
  belongs_to :user
  has_many :gigs
end
