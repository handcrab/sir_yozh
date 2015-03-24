# encoding: utf-8
require 'rails_helper'

RSpec.describe SiteCrawler::Avito do
  subject { SiteCrawler::Avito.new }
  let(:yozh_url) { 'https://www.avito.ru/samarskaya_oblast?q=%D0%B5%D0%B6%D0%B8%D0%BA+%D0%B0%D1%84%D1%80%D0%B8%D0%BA%D0%B0%D0%BD%D1%81%D0%BA%D0%B8%D0%B9' }
  let(:yozh_page) { Mechanize.new.get yozh_url }
  let(:yozh_cassete)     { 'avito/yozh_afrika' }
  let(:yozhiki_cassete)  { 'avito/yozhiki' }
  # it 'test_example_dot_com' do
  #   VCR.use_cassette('synopsis') do
  #     response = Net::HTTP.get_response(URI('http://www.iana.org/domains/reserved'))
  #     assert_match /Example domains/, response.body
  #   end
  # end
  describe '#parse_date' do
    it 'parses dates' do
      Timecop.freeze Time.local(2015, 3, 4) # 4 марта 2015

      date_str = " Вчера 16:36" # 3 марта
      date = subject.parse_date date_str
      
      expect(date.day).to eq 3
      expect(date.month).to eq 3
      expect(date.year).to eq 2015
      expect(date.hour).to eq 16
      expect(date.min).to eq 36

      date_str = "Сегодня 5:02" # 4 марта
      date = subject.parse_date date_str
      expect(date.day).to eq 4
      expect(date.hour).to eq 5
      expect(date.min).to eq 2

      date_str = "14 февраля 12:36"
      date = subject.parse_date date_str

      expect(date.day).to eq 14
      expect(date.month).to eq 2
    end
  end

  describe '#parse_items' do
    it 'parses items on a page' do
      items = []
      VCR.use_cassette(yozh_cassete) do
        items = subject.parse_items yozh_page
      end

      expect(items.size).to eq 3
   
      # oldest = last
      expect(items.last[:title]).to eq 'Продается карликовый африканский ежик'
      expect(items.last[:price]).to eq 5000
      expect(items.last[:description]).not_to be_nil
      expect(items.last[:source_url]).not_to be_nil
      expect(items.last[:picture_url]).not_to be_nil
      expect(items.last[:published_at].day).to eq 14
      expect(items.last[:published_at].month).to eq 2
      expect(items.last[:published_at].year).to eq 2015
    end
  end

  describe '#parse_pages' do
    # parse_pages current_page, args={}, cache=nil
    # default_args = {paginate: true, cooldown: 1, items: []}
    before :each do
      @items = []
    end
    
    context 'a single page of items (no pagination found)' do
      let(:first_item_date)  { Date.new 2015, 3, 4 }
      let(:second_item_date) { Date.new 2015, 3, 2 }
      let(:last_item_date)   { Date.new 2015, 2, 14 }
      

      it 'returns all items on the page if no cache given' do        
        VCR.use_cassette(yozh_cassete) do        
          @items = subject.parse_pages yozh_page
        end
        expect(@items.size).to eq 3
        expect(@items.last[:published_at].to_date).to eq last_item_date      
      end 

      it "returns items that are not older than cache" do      
        # items = []
        cache = stub_model Post, published_at: Time.new(2015, 2, 25) # Y, m, d

        VCR.use_cassette(yozh_cassete) do             
          @items = subject.parse_pages yozh_page, {}, cache
        end    
        expect(@items.size).to eq 2
        # Вчера 16:36
        # 2 марта 16:49 <--
        # 14 февраля 12:36
        expect(@items.last[:published_at].to_date).to eq second_item_date
      end
    end

    context 'page with pagination' do
      # 4 pages
      let(:yozh_yozh_url)   { 'https://www.avito.ru/rossiya?q=%D0%B5%D0%B6%D0%B8%D0%BA+%D0%B0%D1%84%D1%80%D0%B8%D0%BA%D0%B0%D0%BD%D1%81%D0%BA%D0%B8%D0%B9' }
      let(:yozh_multi_page) { Mechanize.new.get yozh_yozh_url }
      let(:last_item_date)  { Date.new 2015, 1, 6 }

      it 'returns all items if no cache given' do
        VCR.use_cassette(yozhiki_cassete) do
          # def parse_pages current_page, args={}, cache=nil
          # default_args = {paginate: true, cooldown: 1, items: []}
          @items = subject.parse_pages yozh_multi_page
        end
        expect(@items.size).to eq 171
        expect(@items.last[:published_at].to_date).to eq last_item_date
      end 


      context 'if cache is given' do
        # cached item is on the same page
        it "returns items that are not older than cache" do
          Timecop.freeze Time.local(2015, 3, 5, 12, 0)
          cache = stub_model Post, published_at: Time.now - 1.day
          #Time.new(2015, 2, 25) # Y, m, d

          VCR.use_cassette(yozhiki_cassete) do
            @items = subject.parse_pages yozh_multi_page, {}, cache
          end 
          
          # item[:published_at]: 2015-03-04 06:28:00 +0300
          # cache.published_at: 2015-03-04 12:00:00 +0300
          # CACHE FOUND: new page items 7

          expect(@items.size).to eq 7
          expect(@items.last[:published_at]).to eq Time.new(2015, 3, 4, 12, 19)
          expect(@items.last[:title]).to eq 'Африканские карликовые ежики из питомника Ежи-DAI'
        end

        # context 'cached item is not on the same page' do
        it "returns items that are not older than cache" do
          Timecop.freeze Time.local(2015, 3, 5)      
          cache = stub_model Post, published_at: Time.new(2015, 2, 16, 16, 00)

          VCR.use_cassette(yozhiki_cassete) do             
            @items = subject.parse_pages yozh_multi_page, {}, cache
          end 

          expect(@items.size).to eq 106
          # expect(@items.last[:published_at]).to eq Time.new(2015, 2, 16, 18, 36)
          expect(@items.last[:title]).to eq 'Африканские карликовые ежи редких окрасов'
          # expect(@items.first[:published_at].to_date).to eq Time.now.yesterday.to_date
          # item[:published_at]: 2015-02-16 15:22:00 +0300
          # cache.published_at: 2015-02-16 16:00:00 +0300
          # CACHE FOUND: new page items 106
        end

        it "returns all items if cache not found" do
          Timecop.freeze Time.local(2015, 3, 5, 12, 0)      
          cache = stub_model Post, published_at: Time.now - 6.months
          VCR.use_cassette(yozhiki_cassete) do             
            @items = subject.parse_pages yozh_multi_page, {}, cache
          end 
          expect(@items.size).to eq 171
        end

      end

      context 'pages with sticked items' do
        it "returns all the items if no cache given" do
          Timecop.freeze Time.local(2015, 3, 5, 12)      
          #cache = stub_model Post, published_at: (Time.now - 4.days)

          VCR.use_cassette('avito/kvartiry_page') do  
            url = 'https://www.avito.ru/samara/kvartiry/sdam/na_dlitelnyy_srok/1-komnatnye?p=3'
            pg = Mechanize.new.get url
            @items = subject.parse_pages pg, {paginate: false} #, cache
          end 

          expect(@items.size).to eq 54
        end   

        it "drops sticked items that older than cache" do
          Timecop.freeze Time.local(2015, 3, 5, 12)      
          cache = stub_model Post, published_at: (Time.now - 1.day)
          
          VCR.use_cassette('avito/kvartiry_page') do   
            url = 'https://www.avito.ru/samara/kvartiry/sdam/na_dlitelnyy_srok/1-komnatnye?p=3'
            # url = 'https://www.avito.ru/samara/kvartiry/sdam/na_dlitelnyy_srok/1-komnatnye'
            pg = Mechanize.new.get url
            @items = subject.parse_pages pg, {paginate: false}, cache
          end 
          
          # STICKED ITEMS: 11
          # 3 old sticks
          expect(@items.size).to eq 51
        end    
      end

    end
  end
end