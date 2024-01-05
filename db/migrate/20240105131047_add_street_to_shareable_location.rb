class AddStreetToShareableLocation < ActiveRecord::Migration[7.1]
  def change
    add_column :shareable_locations, :street, :string
  end
end
