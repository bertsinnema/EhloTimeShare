class AddVisibilityToLocations < ActiveRecord::Migration[7.1]
  def change
    add_column :locations, :public, :boolean
  end
end
