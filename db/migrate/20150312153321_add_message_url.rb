class AddMessageUrl < ActiveRecord::Migration
  def change
  	add_column :guests, :recording_url, :string  	
  end
end
