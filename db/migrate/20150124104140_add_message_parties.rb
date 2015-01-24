class AddMessageParties < ActiveRecord::Migration
  def change
    add_column :parties, :message, :string
  end
end
