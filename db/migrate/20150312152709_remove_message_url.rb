class RemoveMessageUrl < ActiveRecord::Migration
  def change
  	  	remove_column :guests, :message_url
  end
end
