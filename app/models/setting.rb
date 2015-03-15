class Setting < ActiveRecord::Base
  belongs_to :tunable, polymorphic: true
  serialize :stop_words, Array

  after_save :destroy_channel_posts_on_setup_change

  def stop_words=(value)
    value = value.split(',').map(&:strip)
    write_attribute :stop_words, value
  end

  def stop_words_str  # self.stop_words.to_s
    stop_words.join(', ')
  end

  def stop_words_regex
    return nil if stop_words.empty?

    regex_str = stop_words.inject('') do |str, sw|
      str + "(^|\\s+)#{sw}($|\\s+)|"
    end
    /#{regex_str[0..-2]}/i # remove last '|'
  end

  private

  def destroy_channel_posts_on_setup_change
    tunable.posts.destroy_all if tunable.instance_of? Channel
  end
end
