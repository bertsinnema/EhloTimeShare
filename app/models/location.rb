class Location < ApplicationRecord
    has_many :user_locations, dependent: :destroy
    has_many :users, through: :user_locations
    has_many :items, dependent: :destroy
    

    geocoded_by :address   
    after_validation :geocode, if: :address_changed?

    def address
        [street, city, country, zipcode].compact.join(', ')
    end

    private

    def address_changed?
        country_changed? || 
        city_changed? ||
        street_changed? ||
        zipcode_changed?
    end
end
