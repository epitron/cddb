class CreateNodes < ActiveRecord::Migration
  def self.up
    create_table :nodes do |t|
      t.string    :name           ; t.index :name
      t.integer   :parent_id      ; t.index :parent_id
      t.integer   :lent_to_id     ; t.index :lent_to_id
      t.string    :type           ; t.index :type
      t.text      :comment
      t.string    :disc_path
      t.integer   :crate_id
      t.integer   :sleeve_id
      t.integer   :size
      t.datetime  :date
    end

    #Node.create(:name=>"Root", :type=>"Root")
  end

  def self.down
    drop_table :nodes
  end
end
