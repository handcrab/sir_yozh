require 'rails_helper'

RSpec.describe "channels/new", type: :view do
  before(:each) do
    assign(:channel, Channel.new(
      :title => "MyString",
      :source_url => "MyString"
    ))
  end

  it "renders new channel form" do
    render

    assert_select "form[action=?][method=?]", channels_path, "post" do

      assert_select "input#channel_title[name=?]", "channel[title]"

      assert_select "input#channel_source_url[name=?]", "channel[source_url]"
    end
  end
end
