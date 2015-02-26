require 'rails_helper'

RSpec.describe "channels/index", type: :view do
  before(:each) do
    assign(:channels, [
      Channel.create!(
        :title => "Title",
        :source_url => "Source Url"
      ),
      Channel.create!(
        :title => "Title",
        :source_url => "Source Url"
      )
    ])
  end

  it "renders a list of channels" do
    render
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "Source Url".to_s, :count => 2
  end
end
