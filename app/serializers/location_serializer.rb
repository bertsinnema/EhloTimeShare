class LocationSerializer
  include JSONAPI::Serializer
  attributes :name, :city, :country, :public
end