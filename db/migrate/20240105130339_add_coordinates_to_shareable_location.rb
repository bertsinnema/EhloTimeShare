class AddCoordinatesToShareableLocation < ActiveRecord::Migration[7.1]
  def change
    add_column :shareable_locations, :latitude, :float
    add_index :shareable_locations, :latitude
    add_column :shareable_locations, :longitude, :float
    add_index :shareable_locations, :longitude
  end
end
