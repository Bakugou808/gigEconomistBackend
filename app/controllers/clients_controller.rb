class ClientsController < ApplicationController
    before_action :set_client, only: [:show, :update, :destroy]

    def index 
        clients = Client.all  
        render json: clients
    end
 
    def show 
        render json: @client
        # , include: ['profiles']
    end 

    def usersClients
        clients = Client.findClientsFor(params[:user_id])
        
        render json: clients
    end

    def create 
        
        @client = Client.new(client_params)
        if @client.save 
            
            render json: @client
        else
            render json: {error: 'That client could not be created'}, status: 401
        end 
    end 

    def update 
        if @client.update(client_params)
            render json: @client 
        # else 
        end 
    end 

    def destroy 
         id = @client.id
        @client.destroy 
        render json: {resp: "client Deleted", client_id: id}
    end 


    private 

    def set_client 
        
        @client = Client.find(params[:id])
    end 

    def client_params
        params.permit(:company_name, :contact_name, :email, :cell, :venmo, :user_id)
    end 
end
