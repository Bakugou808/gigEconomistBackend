class Client < ApplicationRecord
    belongs_to :user
    has_many :gigs, dependent: :destroy

    def self.findClientsFor(user_id)
        
        # users_services = Service.where(user_id: user_id)
        # gigs = users_services.map{|service|  service.gigs}
        
        # clients = gigs[0].map{|gig| Client.find(gig.client_id)}
        clients = Client.where(user_id: user_id)
        return clients.uniq

    end
end
