atom_feed language: 'ru-RU' do |feed|
  feed.title t('posts.index.title')
  feed.updated @posts.maximum(:published_at)
  # I18n.locale
  @posts.each do |post|
    # configuration options for feed entry
    feed_entry_options = {
      # set entry published date, otherwise will be by default created_at
      published: post.published_at,
      # set entry updated date, otherwise will be by default updated_at
      updated:   post.published_at,
      url:       post.source_url
    }

    feed.entry(post, feed_entry_options) do |entry|
      entry.title "#{post.title} | #{number_to_currency post.price}"
      # entry.url post.source_url
      # entry.content post.description, type: 'html'
      # entry.content image_tag(display_image post.picture_url), type: 'html'
      image = image_tag(display_image post.picture_url) + '<br/>'.html_safe
      content = image + post.description
      entry.content content, type: 'html'

      entry.author do |author|
        author.name 'Avito.ru'
      end
    end
  end
end
