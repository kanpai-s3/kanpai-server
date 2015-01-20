class AddPartyIdGuests < ActiveRecord::Migration
  def change
    add_column :guests, :party_id, :string
  end
end
