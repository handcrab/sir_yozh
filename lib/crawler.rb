class Crawler
  def initialize url, options={}
    agent = Mechanize.new

    begin
      @page = agent.get url
    rescue
      # '404. Page not found'
      return nil
    end
    @cache = options[:cache]
    # определяем парсер по домену
    @engine = case agent.page.uri.host
              when /avito/i
                SiteCrawler::Avito.new
              end
  end

  def run options={}
    return [] unless @engine
    @engine.parse_pages @page, options, @cache
  end
end
