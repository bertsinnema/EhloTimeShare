class ItemSerializer
  include JSONAPI::Serializer
  has_one :location
  
  attributes :name
end
