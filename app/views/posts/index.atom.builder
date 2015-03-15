atom_feed language: 'ru-RU' do |feed|
  feed.title t('posts.index.title')
  feed.updated @posts.maximum(:published_at)
  # I18n.locale
  @posts.each do |post|
    # configuration options for feed entry
    feed_entry_options = {
      published: post.published_at,
      updated:   post.published_at,
      url:       post.source_url
    }

    feed.entry(post, feed_entry_options) do |entry|
      entry.title "#{post.title} | #{number_to_currency post.price}"

      image = if post.picture_url
        image_tag(post.picture_url) + '<br/>'.html_safe
      else
        ''
      end

      content = image + post.description
      entry.content content, type: 'html'

      entry.author do |author|
        author.name 'Avito.ru'
      end
    end
  end
end
