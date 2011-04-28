class Serializeproblems < ActiveRecord::Migration
  def self.up
    create_table :stockdatas do |t|
      t.date     :d
      t.float    :value
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :stockpost_id
    end
    add_index :stockdatas, [:stockpost_id]

    remove_column :portfolios, :history

    remove_column :stockposts, :history
  end

  def self.down
    add_column :portfolios, :history, :text

    add_column :stockposts, :history, :text

    drop_table :stockdatas
  end
end
