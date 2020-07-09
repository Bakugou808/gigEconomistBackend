class UsersController < ApplicationController
    before_action :set_user, only: [:show, :update, :destroy]

    def index 
        users = User.all  
        render json: users
    end
 
    def show 
        render json: @user
        # , include: ['profiles']
    end 

    def currVsProj
        # user = User.find(params[:userId])
        data = User.totalCurrVsProj(params[:user_id])
        render json: data  
        
    end



    def create 
        
        @user = User.new(user_params)
        if @user.save 
            token = issue_token_on_signup(@user)
            render json: {firstName: @user.firstName, lastName: @user.lastName, username: @user.username, id: @user.id, email: @user.email, jwt: token}
        else
            render json: {error: 'That user could not be created'}, status: 401
        end 
    end 

    def update 
        if @user.update(user_params)
            render json:@user 
        # else 
        end 
    end 

    def destroy 
        @user.destroy 
        render json: "User Deleted"
    end 


    private 

    def set_user 
        
        @user = User.find(params[:id])
    end 

    def user_params
        params.permit(:firstName, :lastName, :username, :email, :password, :password_confirmation)
    end 
end
