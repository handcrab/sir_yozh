class Post < ActiveRecord::Base
  belongs_to :channel
  # validates_presence_of :title
  validate :by_settings

  scope :newest_on_top, -> { order published_at: :desc }
  scope :older_than, -> (post) { where 'published_at < ?', post.published_at }

  private

  def by_settings
    return true unless channel.setup

    if price_is_bigger?
      errors.add(:expiration_date, 'rejected by channel setup')
    end

    if title_with_stopwords?
      errors.add(:stop_words, 'rejected by channel setup')
    end
  end

  def title_with_stopwords?
    title =~ channel.setup.stop_words_regex
  end

  def price_is_bigger?
    max_price = channel.setup.max_price.to_i
    price.to_i > max_price && max_price > 0
  end
end
