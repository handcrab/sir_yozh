require 'rails_helper'

RSpec.describe "channels/edit", type: :view do
  before(:each) do
    @channel = assign(:channel, Channel.create!(
      :title => "MyString",
      :source_url => "MyString"
    ))
  end

  it "renders the edit channel form" do
    render

    assert_select "form[action=?][method=?]", channel_path(@channel), "post" do

      assert_select "input#channel_title[name=?]", "channel[title]"

      assert_select "input#channel_source_url[name=?]", "channel[source_url]"
    end
  end
end
