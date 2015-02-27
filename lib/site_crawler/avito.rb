module SiteCrawler
  class Avito
    HOST_NAME = 'http://www.avito.ru'

    def initialize
      @agent_smith = Mechanize.new
    end
    
    # item = Nokogiri::XML::Element
    # => hash of {:title, :price, :source_url, picture_url :published_at, :description}
    def parse_item item
      parsed_item = {}
      parsed_item[:title] = item.at('.description .title').text.strip

      picture = item.at('.photo-wrapper img')
      #parsed_item[:picture] = 'http:' + picture[:src] if picture
      parsed_item[:picture_url] = picture[:src] if picture

      # TODO: price currency
      parsed_item[:price] = item.at('.description .about').text.strip
      parsed_item[:price] = parsed_item[:price].gsub(/[[:space:]]/, '').match(/[[:digit:]]*/)[0]
      parsed_item[:price] = parsed_item[:price].to_i
      
      # agent.page.uri.host
      parsed_item[:source_url] = HOST_NAME + item.at('.title a')[:href]
      parsed_item[:published_at] = parse_date item.at('.date').text.strip    

      # TODO: parse tags
      parsed_item[:description] = item.at('.description').text.strip
      # parsed_item[:is_new] = false # default
      # parsed_item[:is_pinned] = !!(item.attributes["class"].value =~ /premium/)
      
      parsed_item
    end
    
    # page = agent.page
    # => array of hashes
    def parse_items page
      items = page.search '.item'
      parsed_page_items = []

      items.each do |item|
        parsed_item = parse_item item
        #parsed_item = self.new parsed_item
        parsed_page_items << parsed_item
      end

      parsed_page_items
    end

    # current_page = agent.page
    # => array of hashes
    # Recursion
    def parse_pages current_page, args={}    
      default_args = {paginate: true, cooldown: 1, items: []}
      args = default_args.merge args

      parsed_items = args[:items]
      parsed_items += parse_items current_page
      
      # next_button_selector = '.b-paginator .next'    
      next_btn = current_page.link_with text: /Следующ/i, class: 'pagination__page'

      if args[:paginate] && next_btn
        sleep args[:cooldown] # cd
        @agent_smith.click next_btn
        # ☢ Рекурсия ☢
        parse_pages @agent_smith.page, items: parsed_items
      else
        return parsed_items
      end
      # puts 'last: ', parsed_items.size
      # byebug
      # parsed_items
    end
      
    # def parse_pages current_page, paginate=true, cooldown=1
    #   # for 1st time  next_btn=true
    #   next_button_selector = '.b-paginator .next'
    #   next_btn = current_page.at(next_button_selector) || true
    #   parsed_items = []

    #   while next_btn do
    #     # items = agent.page.search('.item')
    #     # parsed_page_items = []
    #     # обработали страницу в parsed_page_items

    #     # parsed_items << parse_page(current_page) 
    #     items = current_page.search('.item')
    #     items.each do |item|
    #       parsed_items << parse_item(item)
    #     end
    #     # parsed_items << current_page.search('.item')
    #     # # parse_page(agent.page)  
    #     # parse_page(current_page).each do |item_hash| 
    #     #   item = self.new item_hash.merge(channel_id: channel.id) 
    #     #   parsed_page_items << item
    #     # end
    #     # Проверка КЭША
    #     # if cache

    #     # parsed_page_items.sort.reverse!                
    #     # сортируем страницу, чтобы "нейтрализовать" прикрепленные      
    #     #.sort_by &:published_at
    #     # reverse: 1й - самый новый [today, yesterday] 


    #     # next_btn = agent.page.at(next_button_selector)
    #     break unless paginate
    #     next_btn = current_page.at(next_button_selector)

    #     if next_btn
    #       sleep cooldown # cd
    #       agent.click next_btn 
    #       current_page = agent.page
    #     end
    #   end

    #   parsed_items.flatten
    # end


    # helpers
    # Public: Создает объект класса Time на основе содержащей дату строки.
    #
    # str  -  строка String, описывающая дату
    #
    # Examples
    #   Time.now
    #   # => 2014-08-26 16:15:51 +0400
    #   parse_date "\n Вчера\n 16:01"
    #   # => 2014-08-25 16:01:00 +0400
    #
    #   parse_date "\n 19 авг.\n 09:00 "
    #   #=> 2014-08-19 09:00:00 +0400
    #
    # Returns объект класса Time.
    def parse_date str
      date = Time.now

      # Ищем в строке время HH:MM 
      parsed_time = str.match /(\d+):(\d+)/
      hour, minute = parsed_time[1], parsed_time[2]

      # Ищем месяц и число
      if str[/(сегодня|вчера)/i]
        # дата описана стоп-словом
        date = date.yesterday if str[/вчера/i]
        day, month = date.day, date.month
      else  
        # возможные значения месяца
        mnths = %w(янв фев мар апр май мая июн июл авг сен окт ноя дек)
        parsed_date = str.match /(?<day>\d+) (?<month>#{ mnths.join('|')})/i
        day = parsed_date[:day]
        month = mnths.index(parsed_date[:month]) + 1
        # коррекция значения, т.к. для мая 2 варианта (май мая) 
        month -= 1 if month > 4 
      end
      # год = текущий
      Time.new date.year, month, day, hour, minute
    end
  end
end