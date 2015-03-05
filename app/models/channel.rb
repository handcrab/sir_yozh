class Channel < ActiveRecord::Base
  belongs_to :user
  has_many :posts, dependent: :destroy
  has_one :setup, as: :tunable, class_name: 'Setting', dependent: :destroy
  # ??? association callbacks
  #, after_add: :destroy_posts_on_setup_change
  accepts_nested_attributes_for :setup

  # ??? reject in-valid attributes for has_many association
  # accepts_nested_attributes_for :posts, reject_if: -> {Post.new(attributes).valid?}
  acts_as_taggable
  
  validates :source_url, presence: true
  validate :source_url, :is_uri_valid

  before_save :generate_title
  after_update :destroy_posts_on_source_url_change 
  # after_update :destroy_posts_on_setup_change

  scope :published, -> { where public: true }
  # scope :published_and_personal_for, ->(user) {}
  def self.published_and_personal_for user
    where 'public = ? OR (user_id = ? AND public = ?)', true, user, false
  end

  # => posts
  def fetch 
    crawler = Crawler.new source_url, cache: cached_post    
    posts = if crawler
      crawler.run 
    # else
    #   []
    end

    return [] if posts.present?

    # TODO
    unless posts.empty?
      # drop extra attributes
      posts.map! do |post|
        post.with_indifferent_access.slice *Post.attribute_names
      end      
      self.posts.create posts.sort_by{|post| post[:published_at]} #unless posts.empty?
    end
  end

  # => [] of post attributes
  def get_posts
    crawler = Crawler.new source_url, cache: cached_post    
    posts = if crawler
      crawler.run     
    end

    return [] unless posts.present?

    posts.map! do |post|
      post.merge! channel_id: id
      post.with_indifferent_access.slice *Post.attribute_names
    end.sort_by{|post| post[:published_at]}    
  end

  def self.fetch_all_posts
    posts_arr = all.inject([]) { |posts, channel| posts + channel.get_posts }    
    Post.create posts_arr
  end

  def cached_post
    cache = posts.last # find by max Time
    offset_date = Time.now - setup.shift_days.to_i.days
    # если posts.last.nil? пропустить записи старше offset_date
    tmp_post = Post.new published_at: offset_date
    cache ||= tmp_post

    # если posts.last в кэше, но старше offset_date
    # ??? сразу вернуть tmp_post
    cache = tmp_post if offset_date > cache.published_at    
    cache
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

  def destroy_posts
    posts.destroy_all
  end

  def destroy_posts_on_source_url_change
    destroy_posts unless source_url_was == source_url
  end

  # def destroy_posts_on_setup_change
  # end
end
