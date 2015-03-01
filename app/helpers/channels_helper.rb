module ChannelsHelper
  include ActsAsTaggableOn::TagsHelper

  def link_to_edit channel
    link_to edit_channel_path channel do
      content_tag :i, '', class: 'mdi-content-create'
      #| Edit      
    end if channel.user == current_user
  end

  def link_to_delete channel
    link_to channel, data: {confirm: t('.confirm.destroy', channel: channel.title) }, method: :delete do
      #| Destroy
      content_tag :i, '', class: 'mdi-content-clear'
    end if channel.user == current_user
  end

  def setup_report_str channel
    "≤ #{number_to_currency channel.setup.max_price}, 
    не более #{channel.setup.shift_days} дней назад"
  end
end
