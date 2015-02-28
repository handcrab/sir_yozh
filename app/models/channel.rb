class Channel < ActiveRecord::Base
  belongs_to :user
  has_many :posts, dependent: :destroy
  has_one :setup, as: :tunable, class_name: 'Setting'
  accepts_nested_attributes_for :setup

  acts_as_taggable
  
  validates :source_url, presence: true
  validate :source_url, :is_uri_valid

  before_save :generate_title
  before_update :destroy_posts_on_source_url_change

  scope :published, -> { where public: true }
  # scope :published_and_personal_for, ->(user) {}

  def self.published_and_personal_for user
    where 'public = ? OR (user_id = ? AND public = ?)', true, user, false
  end

  # => posts
  def fetch 
    crawler = Crawler.new source_url, cache: cached_post    
    if crawler
      crawler.run 
    else
      []
    end
  end

  def cached_post
    # offset_date = Time.now - channel.shift_days.to_i.days
    # cache = self.where(channel_id: channel.id).last
    # cache ||= self.new published_at: offset_date
    # cache.published_at = offset_date if cache.published_at < offset_date      
    # cache
    posts.last
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

  def destroy_posts_on_source_url_change
    self.posts.destroy_all unless source_url_was == source_url
  end
end
