class CreateWeathers < ActiveRecord::Migration
  def change
    create_table :weathers do |t|
      t.date :date, null: false
      t.text :temperature, null: false, array: true
      t.references :location, null: false, foreign_key: true
    end
  end
end
