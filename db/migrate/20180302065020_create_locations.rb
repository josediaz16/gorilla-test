class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.decimal :lat, null: false, scale: 4, precision: 12
      t.decimal :lon, null: false, scale: 4, precision: 12
      t.string  :city, null: false
      t.string  :state, null: false
    end
  end
end
