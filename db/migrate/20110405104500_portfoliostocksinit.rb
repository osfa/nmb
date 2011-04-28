class Portfoliostocksinit < ActiveRecord::Migration
  def self.up
    create_table :portfolios do |t|
      t.string   :name
      t.text     :description
      t.float    :value
      t.datetime :created_at
      t.datetime :updated_at
    end

    create_table :stockposts do |t|
      t.string   :name
      t.date     :acquired
      t.integer  :amount
      t.float    :value
      t.float    :acquiredprice
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :portfolio_id
    end
    add_index :stockposts, [:portfolio_id]
  end

  def self.down
    drop_table :portfolios
    drop_table :stockposts
  end
end
