class AddInventoryToProduct < ActiveRecord::Migration
  def self.up
    add_column :products, :inventory, :integer, :default => 0
  end

  def self.down
    remove_column :products, :inventory
  end
end
