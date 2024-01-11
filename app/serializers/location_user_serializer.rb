class LocationUserSerializer
  include JSONAPI::Serializer
  attributes :role
  has_one :user

  # attribute :role do |user, params|
  #   location_id = params[:location_id]
    
  #   user_location = user.user_locations.find_by(location_id: location_id)
  #   user_location&.role
  # end
end
