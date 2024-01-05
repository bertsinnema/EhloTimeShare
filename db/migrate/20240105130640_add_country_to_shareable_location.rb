class AddCountryToShareableLocation < ActiveRecord::Migration[7.1]
  def change
    add_column :shareable_locations, :country, :string
  end
end
