class CreateParties < ActiveRecord::Migration
  def change
    create_table :parties, id: false do |t|
      t.string :id, null: false
      t.string :owner, null: false
      t.datetime :begin_at, null: false
      t.string :location, null: false
      t.timestamps
    end
    add_index :parties, :id, unique: true
  end
end
