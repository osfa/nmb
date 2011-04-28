class History4portfolio < ActiveRecord::Migration
  def self.up
    add_column :portfolios, :history, :text
  end

  def self.down
    remove_column :portfolios, :history
  end
end
