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

  # TODO
  def atom_link request
    # request.original_url+'.atom'
    page = request.env['PATH_INFO']
    query = request.env['QUERY_STRING']
    query = query.empty? ? '' : '?'+query

    # raise request.inspect
    "http://#{request.host_with_port}#{page}.atom#{query}"
  end
end
