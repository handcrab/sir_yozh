require 'rails_helper'

RSpec.feature 'show channel page' do
  before(:each) do
    Timecop.freeze Time.local(2015, 2, 25)
    given_there_are_public_and_private_channels
    visit root_path
  end

  scenario 'for anonymous user' do
    when_i_click_on_a_channel_link
    then_i_should_see_the_channel_page
    and_i_should_not_see_the_channel_controls
  end

  scenario 'for author' do
    given_i_am_an_authenticated_user :hodor
    when_i_click_on_a_channel_link
    then_i_should_see_the_channel_page
    and_i_should_see_the_channel_controls
  end

  def when_i_click_on_a_channel_link
    VCR.use_cassette('avito/yozh_afrika') do
      visit channel_path @public_channel
    end
  end

  def then_i_should_see_the_channel_description
    within '.channel-card' do
      find_link @public_channel.title
    end
  end

  def and_i_should_not_see_the_channel_controls
    expect(page).not_to have_css '.card-action a'
  end

  def and_i_should_see_the_channel_controls
    expect(page).to have_css '.card-action a'
  end

  def and_i_should_see_the_channel_posts
    expect(page).to have_css '#posts'

    user_posts = @public_channel.posts
    counter = page.find('.posts-count').text.to_i
    expect(counter).to eq user_posts.size

    posts = page.all '#posts .post'
    expect(posts.size).to eq user_posts.size # 2

    expect(page).to have_link user_posts.first.title,
                              href: user_posts.first.source_url
  end

  def then_i_should_see_the_channel_page
    then_i_should_see_the_channel_description
    and_i_should_see_the_channel_posts
  end
end
