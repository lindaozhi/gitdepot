class AddSalesToProduct < ActiveRecord::Migration
  def self.up
    add_column :products, :sales, :integer, :default => 0
  end

  def self.down
    remove_column :products, :sales
  end
end
