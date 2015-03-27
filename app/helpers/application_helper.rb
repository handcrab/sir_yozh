module ApplicationHelper
  def display_image img_url
    img_url || 'rss-icon.png'
  end

  def formatted_date date
    l date, format: :short
  end

  def display_post_count channel
    count = channel.posts_count # posts.count
    count.zero? ? '' : count.to_s
  end

  # TODO
  def atom_link request
    page = request.env['PATH_INFO']
    query = request.env['QUERY_STRING']

    query_str = '?'
    query_str += query unless query.empty?
    query_str += "&token=#{current_user.token}" if current_user

    "http://#{request.host_with_port}#{page}.atom#{query_str}"
  end

  def get_token channel
    # unless channel.public?
    return nil unless current_user
    current_user.token if channel.user == current_user
  end

  # patch :monkey_face:
  # fix: auto-discovery link + turbolinks
  def auto_discovery_link_tag(type = :rss, url_options = {}, tag_options = {})
    if !(type == :rss || type == :atom) && tag_options[:type].blank?
      raise ArgumentError.new("You should pass :type tag_option key explicitly, because you have passed #{type} type other than :rss or :atom.")
    end

    tag_options.merge!({
      "rel"   => tag_options[:rel] || "alternate",
      "type"  => tag_options[:type] || Mime::Type.lookup_by_extension(type.to_s).to_s,
      "title" => tag_options[:title] || type.to_s.upcase,
      "href"  => url_options.is_a?(Hash) ? url_for(url_options.merge(:only_path => false)) : url_options
    })

    tag("link", tag_options)
  end
end
