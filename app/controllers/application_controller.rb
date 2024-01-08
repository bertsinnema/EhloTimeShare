class ApplicationController < ActionController::API
    before_action :configure_permitted_parameters, if: :devise_controller?
  
    protected
  
    def parsed_json_request
    
        @parsed_json = JSON.parse(request.body.read)
        # Assuming you use strong parameters
        @parsed_json = @parsed_json.dig('data', 'attributes') || {}
      
    rescue JSON::ParserError
        render json: { errors: ['Invalid JSON'] }, status: :unprocessable_entity
    end

    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: %i[name avatar])
        devise_parameter_sanitizer.permit(:account_update, keys: %i[name avatar])
    end
end
