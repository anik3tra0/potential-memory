class CreateAccount

    def initialize(params)
        @account_params = { subdomain: params.dig(:subdomain), business_name: params.dig(:business_name) }
        @user_params = { username: params.dig(:username), email: params.dig(:email), password: params.dig(:password) }
    end

    def save
        ActiveRecord::Base.transaction do
            account = Account.new(@account_params)
            account.save
            user = account.users.new(@user_params)
            user.save
        end  
    end

end
