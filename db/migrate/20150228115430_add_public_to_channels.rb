class AddPublicToChannels < ActiveRecord::Migration
  def change
    add_column :channels, :public, :boolean, default: true
  end
end
