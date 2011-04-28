class Colorserialize < ActiveRecord::Migration
  def self.up
    add_column :portfolios, :hexcolor, :string

    add_column :stockposts, :history, :text
    remove_column :stockposts, :acquiredprice
  end

  def self.down
    remove_column :portfolios, :hexcolor

    remove_column :stockposts, :history
    add_column :stockposts, :acquiredprice, :float
  end
end
