class RemoveAddressFromShareableLocation < ActiveRecord::Migration[7.1]
  def change
    remove_column :shareable_locations, :address
  end
end
