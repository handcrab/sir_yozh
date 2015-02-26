require 'rails_helper'

RSpec.describe "Channels", type: :request do
  describe "GET /channels" do
    it "works! (now write some real specs)" do
      get channels_path
      expect(response).to have_http_status(200)
    end
  end
end
