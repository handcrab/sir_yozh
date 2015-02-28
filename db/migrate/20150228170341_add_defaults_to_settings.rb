class AddDefaultsToSettings < ActiveRecord::Migration
  def up
    change_column :settings, :max_price,  :string, default: '5000'
    change_column :settings, :shift_days, :integer, default: 5
  end

  def down
    change_column :settings, :max_price,  :string, default: nil
    change_column :settings, :shift_days, :integer, default: nil
  end
end
