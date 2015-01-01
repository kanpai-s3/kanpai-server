class AddContactIdGuests < ActiveRecord::Migration
  def change
  	add_column :guests, :contact_id, :string
  end
end
