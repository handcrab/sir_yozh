# require 'mechanize'
# require 'active_support/all' # date helpers
# require 'byebug'
class Crawler
  def initialize url, options={}
    agent = Mechanize.new
     
    begin 
      @page = agent.get url
    rescue 
      # '404. Page not found'
      return nil
    end

    # определяем парсер по домену  
    @engine = case agent.page.uri.host
    when /avito/i
      SiteCrawler::Avito.new
    end
  end

  def run options={}
    @engine.parse_pages @page, options
  end
end


# url = 'https://www.avito.ru/rossiya?q=%D0%B1%D0%B0%D0%B9%D0%B4%D0%B0%D1%80%D0%BA%D0%B0+%D1%82%D0%B0%D0%B9%D0%BC%D0%B5%D0%BD%D1%8C+3'
# url2 = 'https://www.avito.ru/rossiya?q=%D0%BC%D0%B8%D0%BD%D0%B8%D1%82%D1%80%D0%B0%D0%BA%D1%82%D0%BE%D1%80+%D1%81%D0%B0%D0%BC%D0%BE%D0%B4%D0%B5%D0%BB%D1%8C%D0%BD%D1%8B%D0%B9'
# url3 = 'https://www.avito.ru/udmurtiya/dlya_doma_i_dachi?q=%D0%BD%D0%B5%D1%80%D0%B6%D0%B0%D0%B2%D0%B5%D0%B9%D0%BA%D0%B0'
# c = Crawler.new url3
# items = c.run
# # byebug
# # items.each {|i| p i}
# puts "============"
# puts items.size
# puts "============"