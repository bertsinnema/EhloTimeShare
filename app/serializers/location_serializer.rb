class LocationSerializer
  include JSONAPI::Serializer
  attributes :name, :city, :country, :public

  attribute :owner, if: Proc.new { |record, params|
    owner_user_location = record.user_locations.find_by(role: 'owner')
    owner_user_location.present?
  } do |location, params|
    owner_user_location = location.user_locations.find_by(role: 'owner')
    UserSerializer.new(owner_user_location.user).as_json
  end
  
end
