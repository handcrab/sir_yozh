class CreateChannels < ActiveRecord::Migration
  def change
    create_table :channels do |t|
      t.string :title
      t.text :source_url, limit: 2000,  null: false, index: true

      t.timestamps null: false
    end
  end
end
