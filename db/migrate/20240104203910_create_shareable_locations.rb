class CreateShareableLocations < ActiveRecord::Migration[7.1]
  def change
    create_table :shareable_locations do |t|
      t.string :name
      t.string :address
      t.string :zipcode
      t.string :city

      t.timestamps
    end
  end
end
