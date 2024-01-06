class LocationUserSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :role

  attribute :role do |user, params|
    location_id = params[:location_id]
    
    user_location = user.user_locations.find_by(location_id: location_id)
    user_location&.role
  end
end
