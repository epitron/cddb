class CreateNodes < ActiveRecord::Migration
  def self.up
    create_table :nodes do |t|
      t.integer   :parent_id
      t.string    :type
      t.string    :name
      t.text      :comment
      t.string    :disc_path
      t.datetime  :date
      t.integer   :lent_to_id

      # indexes
      t.index     :name
      t.index     :parent_id
      t.index     :lent_to_id
      t.index     :type
    end
  end

  def self.down
    drop_table :nodes
  end
end
