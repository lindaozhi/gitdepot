class AddOrderstatusToOrder < ActiveRecord::Migration
  def self.up
    add_column :orders, :orderstatus, :integer, :default => 0
  end

  def self.down
    remove_column :orders, :orderstatus
  end
end
