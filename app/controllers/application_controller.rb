class ApplicationController < ActionController::API
<<<<<<< HEAD
    respond_to :json
=======
    before_action :cors_preflight_check
    after_action :cors_set_access_control_headers

    def cors_preflight_check
        return unless request.method == 'OPTIONS'
        headers['Access-Control-Allow-Origin'] = '*'
        headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
        headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version, Token'
        headers['Access-Control-Max-Age'] = '1728000'
        render text: '', content_type: 'text/plain'
    end

    def cors_set_access_control_headers
        headers['Access-Control-Allow-Origin'] = '*'
        headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
        headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept, Authorization, Token'
        headers['Access-Control-Max-Age'] = '1728000'
    end
>>>>>>> fd3f9bb54a5fcaf489712c6c7cd4f7f3ab4b8fcd
end
