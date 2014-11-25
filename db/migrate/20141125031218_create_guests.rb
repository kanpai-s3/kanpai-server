class CreateGuests < ActiveRecord::Migration
  def change
    create_table :guests, id: false do |t|
      t.string :id, null: false
      t.string :name, null: false
      t.boolean :attendance
      t.string :message_url
      t.string :url
      t.timestamps
    end
    add_index :guests, :id, unique: true
  end
end
