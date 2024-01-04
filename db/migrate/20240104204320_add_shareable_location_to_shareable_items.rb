class AddShareableLocationToShareableItems < ActiveRecord::Migration[7.1]
  def change
    add_reference :shareable_items, :shareable_location, null: false, foreign_key: true
  end
end
