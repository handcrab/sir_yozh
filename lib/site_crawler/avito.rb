# require 'mechanize'
# require 'active_support/all' # date helpers
# require 'byebug'
# require 'active_support/core_ext/hash'

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
      # parsed_item[:picture] = 'http:' + picture[:src] if picture
      parsed_item[:picture_url] = picture[:src] if picture

      # TODO: price with currency
      parsed_item[:price] = item.at('.description .about').text.strip
      parsed_item[:price] = parsed_item[:price].gsub(/[[:space:]]/, '').match(/[[:digit:]]*/)[0]
      parsed_item[:price] = parsed_item[:price].to_i
      
      # agent.page.uri.host
      parsed_item[:source_url] = HOST_NAME + item.at('.title a')[:href]

      parsed_item[:published_at] = parse_date item.at('.date').text.strip

      # TODO: parse tags
      parsed_item[:description] = item.at('.description').text.strip

      parsed_item[:sticked] = item.at('.vas-applied').present?
      parsed_item
    end

    # page = agent.page
    # => array of hashes
    def parse_items page
      items = page.search '.item'
      parsed_page_items = []

      items.each do |item|
        parsed_item = parse_item item
        # parsed_item = self.new parsed_item
        parsed_page_items << parsed_item
      end

      parsed_page_items.sort_by { |item| item[:published_at] }.reverse
    end

    # current_page = agent.page
    # => array of hashes
    def parse_pages current_page, args={}, cache=nil
      default_args = { paginate: true, cooldown: 1, items: [] }
      args = default_args.merge args

      parsed_items = args[:items]

      current_page_items = parse_items current_page

      # CHECK CACHE
      if cache
        tmp = []
        cache_found = false

        # items on the current page ~ cache?
        current_page_items.each do |item|
          # TODO опубликованы в одно время (? см title, body)
          if item[:published_at] <= cache.published_at
            next if item[:sticked] # sticked item cant be cached

            puts '------------------------------------'
            puts "item[:published_at]: #{item[:published_at]}"
            puts "cache.published_at: #{cache.published_at}"
            puts "CACHE FOUND: new page items #{tmp.size}"
            puts '------------------------------------'

            cache_found = true
            break # cache_found
          else
            tmp << item
          end
        end

        return drop_sticked_items(parsed_items + tmp, cache) if cache_found
      end # /CHECK CACHE

      # cache not found:
      parsed_items += current_page_items

      # next_button_selector = '.b-paginator .next'
      next_btn = current_page.link_with text: /Следующ/i,
                                        class: 'pagination__page'

      # go to the next page?
      if args[:paginate] && next_btn
        sleep args[:cooldown] # saves from ban
        @agent_smith.click next_btn
        # ☢ Рекурсия ☢
        parse_pages @agent_smith.page, args.merge(items: parsed_items), cache
      else
        return drop_sticked_items(parsed_items, cache)
      end
      # byebug
      # parsed_items
    end

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

    def drop_sticked_items items, cache=nil
      return items unless cache

      # drop old sticked items
      items.select do |item|
        if item[:sticked]
          item[:published_at] > cache.published_at
        else
          true
        end
      end
    end
  end
end
