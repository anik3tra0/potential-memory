class AccountsController < ApplicationController

    def create
        create_account = CreateAccount.new(account_params)
        if create_account.save
            render json: { success: true, message: 'Succesfully Created Account', account: create_account.account }
        else
            render json: { success: false, message: 'Account Could Not Be Created' }
        end
    end

    private

    def account_params
        params.require(:account).permit(:business_name, :subdomain, :email, :password, :username)
    end

end
