class UserSerializer < ActiveModel::Serializer
  attributes :id, :firstName, :lastName, :password_digest, :email, :username 
end
