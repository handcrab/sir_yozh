module ApplicationHelper
  def display_image img_url
    img_url || 'rss-icon.png'
  end

  def formatted_date date
    l date, format: :short
  end

  def display_post_count channel
    count = channel.posts.count
    count.zero? ? '' : count.to_s
  end
end
