module ChannelsHelper
  include ActsAsTaggableOn::TagsHelper

  def link_to_edit channel
    link_to edit_channel_path channel do
      content_tag :i, '', class: 'mdi-content-create channel-edit'
    end if channel.user == current_user
  end

  def link_to_delete channel
    confirm_msg = t('channels.index.confirm.destroy', channel: channel.title)
    link_to channel, data: { confirm:  confirm_msg }, method: :delete do
      content_tag :i, '', class: 'mdi-content-clear channel-destroy'
    end if channel.user == current_user
  end

  def setup_report_str channel
    "≤ #{number_to_currency channel.setup.max_price},
    не более #{channel.setup.shift_days} дней назад"
  end

  def atom_url channel
    # channel_posts_path channel, format: :atom, fetch: true, token: get_token(channel)
    channel_posts_path channel, format: :atom, token: get_token(channel)
  end
end
