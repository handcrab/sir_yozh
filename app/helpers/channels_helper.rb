module ChannelsHelper
  include ActsAsTaggableOn::TagsHelper

  def link_to_edit channel
    link_to edit_channel_path channel do
      content_tag :i, '', class: 'mdi-content-create'
      #| Edit      
    end
  end

  def link_to_delete channel
    link_to channel, data: {confirm: 'Are you sure?'}, method: :delete do
      #| Destroy
      content_tag :i, '', class: 'mdi-content-clear'
    end
  end

end
