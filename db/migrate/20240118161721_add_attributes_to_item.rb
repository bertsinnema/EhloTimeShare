class AddAttributesToItem < ActiveRecord::Migration[7.1]
  def change
    add_column :items, :description, :text
    add_column :items, :active, :boolean
  end
end
