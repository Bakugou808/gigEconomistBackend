class ClientSerializer < ActiveModel::Serializer
  attributes :id, :company_name, :contact_name, :email, :cell, :venmo, :user_id
  has_many :gigs
end
