class AddIndexesToChannels < ActiveRecord::Migration
  def change
    add_index :channels, :public
  end
end
