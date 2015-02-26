json.array!(@channels) do |channel|
  json.extract! channel, :id, :title, :source_url
  json.url channel_url(channel, format: :json)
end
