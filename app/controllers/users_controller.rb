class UsersController < ApplicationController
    skip_before_action :authenticate_user, only: :login
    
    def index
        render json: User.all
    end

    def create
        @user = User.new(user_params)
        if @user.save
            render json: { success: true, message: 'Succesfully Created User', object: @user }
        else
            render json: { success: false, message: 'User could not be created' }
        end
    end

    def update
        @user = User.find_by_id(params[:id])
        if @user.update(user_params)
            render json: { success: true, message: 'Succesfully Updated User', object: @user }
        else
            render json: { success: false, message: 'User could not be updated' }
        end
    end

    def login
        @user = User.find_by_email(user_params.dig(:email))
        if (@user && @user.password === user_params.dig(:password))
            render json: { success: true, message: 'Logged in Successfully', object: @user }
        else
            render json: { success: false, message: 'Invalid Logins' }
        end
    end

    private

    def user_params
        params.require(:user).permit(:email, :password, :username, :id, :account_id)
    end
end