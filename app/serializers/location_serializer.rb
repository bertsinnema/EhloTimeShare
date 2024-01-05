class LocationSerializer
  include JSONAPI::Serializer
  attributes :name, :address
end
