class CreateAccount

    def initialize(params)
        @account_params = { subdomain: params.dig(:subdomain), business_name: params.dig(:business_name) }
        @user_params = { username: params.dig(:username), email: params.dig(:email), password: params.dig(:password) }
    end

    def save
        ActiveRecord::Base.transaction do
            account = Account.new(@account_params)
            account.save
            Apartment::Tenant.switch!(account.subdomain)
            user = User.new(@user_params)
            user.save
        end
    end

    def account
        Account.find_by_subdomain(@account_params.dig(:subdomain))
    end

    def user
        User.find_by_email(@user_params.dig(:email))
    end

end
