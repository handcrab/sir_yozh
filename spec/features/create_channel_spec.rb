require 'rails_helper'

RSpec.feature 'create channel' do
  before(:each) do
    given_there_is_a_registered_user :vasia
  end

  scenario 'as anonymous user' do
    given_i_am_on root_path
    when_i_click_on_add_channel_link
    then_i_should_see_sign_up_form
  end

  scenario 'as authenticated user' do
    given_i_am_an_authenticated_user :vasia
    and_i_am_on root_path
    when_i_click_on_add_channel_link
    and_fill_in_the_form_with_valid_data
    then_channel_should_be_created
  end

  def when_i_click_on_add_channel_link
    click_link I18n.t('channels.index.new_channel')
  end

  def then_i_should_be_on_the_index_page
    expect(current_path).to eq root_path
  end

  def and_fill_in_the_form_with_valid_data
    expect(page).to have_css 'form#new_channel'

    @channel = attributes_for :new_channel
    fill_in 'channel_title', with: @channel[:title]
    fill_in 'channel_source_url', with: @channel[:source_url]
    find('[type="submit"]').click
  end

  def and_i_should_see_success_message
    expect(page).to have_content I18n.t('flash.create.success')
  end

  def then_i_should_be_on_the_channel_page
    within '.channel-card' do
      find_link @channel[:title], @channel[:source_url]
    end
  end

  def then_channel_should_be_created
    then_i_should_be_on_the_channel_page
    and_i_should_see_the_channel_controls
  end
end
