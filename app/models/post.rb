class Post < ActiveRecord::Base
  belongs_to :channel
  # validates_presence_of :title
  validate :by_settings

  private
  def by_settings
    if channel.setup
      max_price = channel.setup.max_price.to_i
      if price.to_i > max_price && max_price > 0
        errors.add(:expiration_date, 'rejected by channel setup')
      end
    end
  end
end
