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
    # query = query.empty? ? '' : '?'+query
    # url.include?('?') ? '&' : '?'
    query_str = '?'
    query_str += query unless query.empty?

    if current_user
      query_str += "&token=#{current_user.token}"
    end

    "http://#{request.host_with_port}#{page}.atom#{query_str}"
  end

  def get_token channel
    # unless channel.public?
    token = current_user.token if channel.user == current_user    
    rescue nil 
  end

  # !!! monkey patch :monkey_face:
  def auto_discovery_link_tag(type = :rss, url_options = {}, tag_options = {})
    if !(type == :rss || type == :atom) && tag_options[:type].blank?
      raise ArgumentError.new("You should pass :type tag_option key explicitly, because you have passed #{type} type other than :rss or :atom.")
    end

    tag(
      "link",
      "rel"   => tag_options[:rel] || "alternate",
      "type"  => tag_options[:type] || Mime::Type.lookup_by_extension(type.to_s).to_s,
      "title" => tag_options[:title] || type.to_s.upcase,
      "href"  => url_options.is_a?(Hash) ? url_for(url_options.merge(:only_path => false)) : url_options,
      # 'data-no-turbolink' => true
      'data-turbolinks-track' => false
    )
  end

end
