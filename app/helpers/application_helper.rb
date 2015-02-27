module ApplicationHelper
  def display_image img_url
    img_url || 'rss-icon.png'
  end

  def formatted_date date
    l date, format: :short
  end
end
