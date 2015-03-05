class FetchChannelsPostsJob
  @queue = :default

  def self.perform channel_ids=[]
    channels = Channel.where id: channel_ids
    channels.each(&:fetch)
  end
end

 