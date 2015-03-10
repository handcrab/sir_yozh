class Setting < ActiveRecord::Base
  belongs_to :tunable, polymorphic: true

  after_save :destroy_channel_posts_on_setup_change

  def destroy_channel_posts_on_setup_change
    tunable.posts.destroy_all if tunable.instance_of? Channel
  end
end
