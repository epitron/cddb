class FulltextIndex < ActiveRecord::Migration
  def self.up
    execute("CREATE FULLTEXT INDEX fulltext_nodes_on_name ON nodes(name)")
  end

  def self.down
    execute("DROP INDEX fulltext_nodes_on_name ON nodes")
  end
end
