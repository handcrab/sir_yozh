class Channel < ActiveRecord::Base
  belongs_to :user
  has_many :posts, dependent: :destroy

  validates :source_url, presence: true
  validate :source_url, :is_uri_valid

  before_save :generate_title

  def fetch
    crawler = Crawler.new source_url    
    crawler.run if crawler
  end

  private
  def generate_title
    return title unless title.strip.empty?      
    url = URI source_url
    begin
      str = URI.unescape url.query
      str = str.scan(/[^&;]+?=([^&;]*)/).join('; ').mb_chars.titleize.to_s        
    rescue
      str = url.host
    end
    self.update title: str
  end

  def is_uri_valid
      URI source_url    
    rescue
      errors.add(:source_url, "Invalid URI")
  end
end
