require 'rails_helper'

RSpec.describe Crawler do
  subject { Crawler.new '' }
  it 'is an instance of Crawler' do
    expect(subject.class).to eq(Crawler)
  end
  # it 'responds to cache' do
  #   expect(subject).to respond_to(:cache)
  # end
end
