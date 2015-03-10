class Post < ActiveRecord::Base
  belongs_to :channel
  # validates_presence_of :title
  validate :by_settings

  scope :newest_on_top, -> { order published_at: :desc }

  private

  def by_settings
    return true unless channel.setup
    max_price = channel.setup.max_price.to_i
    if price.to_i > max_price && max_price > 0
      errors.add(:expiration_date, 'rejected by channel setup')
    end
  end
end
