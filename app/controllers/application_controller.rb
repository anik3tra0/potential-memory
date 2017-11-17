class ApplicationController < ActionController::API
    respond_to :json
    before_action :authenticate_user

    private

    def authenticate_user
        user = User.find_by_token(request.headers["X-Token"])
        render json: {success: false, message: 'Invalid Token'} unless user
    end
end
