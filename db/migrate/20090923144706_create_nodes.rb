class CreateNodes < ActiveRecord::Migration
  def self.up
    create_table :nodes, :options=>"ENGINE MyISAM" do |t|
      t.string    :name
      t.integer   :parent_id
      t.string    :type
      t.integer   :lent_to_id

      t.text      :comment
      t.string    :disc_path
      t.integer   :crate_id
      t.integer   :sleeve_id
      t.integer   :size
      t.datetime  :date
    end

    

    add_index :nodes, :name
    add_index :nodes, :parent_id
    add_index :nodes, :type
    add_index :nodes, :lent_to_id 
    #add_index(table_name, column_names, options): Adds a new index with the name of the column.
    # Other options include :name and :unique (e.g. { :name => "users_name_index", :unique => true }).
  end

  def self.down
    drop_table :nodes
  end
end
