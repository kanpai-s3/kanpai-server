class AddPhoneNumber2 < ActiveRecord::Migration
  def change
  	add_column :guests, :phone_number, :string
  end
end
