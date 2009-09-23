class FixSizes < ActiveRecord::Migration
  def self.up
    change_column :nodes, :size, :integer, :limit=>8    
  end

  def self.down
  end
end
