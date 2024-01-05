class ChangeLocationItemRelationShipColumnName < ActiveRecord::Migration[7.1]
  def change
    rename_column :items, :shareable_location_id, :location_id
  end
end
