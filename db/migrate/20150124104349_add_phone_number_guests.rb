class AddPhoneNumberGuests < ActiveRecord::Migration
  def change
    add_column :guests, :phone_number, :integer
  end
end
