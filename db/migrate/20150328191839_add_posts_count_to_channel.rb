class AddPostsCountToChannel < ActiveRecord::Migration
  def up
    add_column :channels, :posts_count, :integer, default: 0, null: false

    # update all present
    Channel.connection.execute <<-SQL
      UPDATE channels
      SET posts_count =
      (SELECT COUNT(*)
       FROM posts
       WHERE channel_id = channels.id)
    SQL
  end

  def down
    remove_column :channels, :posts_count
  end
end
