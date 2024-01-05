class RenameShareableItemsToItems < ActiveRecord::Migration[7.1]
  def change
    rename_table :shareable_items, :items
  end
end
