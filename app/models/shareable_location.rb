class ShareableLocation < ApplicationRecord
    has_many :shareable_items

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
