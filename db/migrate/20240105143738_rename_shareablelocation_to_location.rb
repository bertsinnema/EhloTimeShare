class RenameShareablelocationToLocation < ActiveRecord::Migration[7.1]
  def change
    rename_table :shareable_locations, :locations
  end
end
