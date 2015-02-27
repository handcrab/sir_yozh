class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.string :source_url
      t.string :picture_url
      t.datetime :published_at
      t.string :price
      t.text :description      
      t.references :channel, index: true

      t.timestamps null: false
    end
    add_foreign_key :posts, :channels
  end
end
