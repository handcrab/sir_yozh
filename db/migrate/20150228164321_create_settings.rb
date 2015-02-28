class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :max_price
      t.integer :shift_days
      t.references :tunable, polymorphic: true, index: true
      t.timestamps null: false
    end    
  end
end

