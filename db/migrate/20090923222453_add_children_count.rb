class AddChildrenCount < ActiveRecord::Migration
  def self.up
    add_column :nodes, :children_count, :integer, :default => 0

    puts "* Updating children_count..."

    record_count = 0
    Node.each do |n|
      if (c = n.children.count) > 0
        n.children_count = c
        n.save
      end

      if record_count % 1768 == 0
        puts "  |_ #{record_count} records..."
      end
    end
    
    puts "  |_ #{record_count} records..."
  end

  def self.down
  end
end
