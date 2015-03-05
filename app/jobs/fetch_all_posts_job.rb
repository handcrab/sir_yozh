class FetchAllPostsJob
  @queue = :default

  def self.perform 
    Channel.all.each(&:fetch)
  end
end