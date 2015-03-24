require 'rails_helper'

RSpec.feature 'delete channel' do
  before(:each) do
    Timecop.freeze Time.local(2015, 2, 25)
    given_there_are_public_and_private_channels
    given_i_am_an_authenticated_user :hodor
  end

  scenario 'as author from show page' do
    and_i_am_on_a_channel_page
    when_i_click_on_delete_link
    then_the_channel_should_be_deleted
  end

  scenario 'as author from index page' do
    and_i_am_on root_path
    when_i_click_on_the_channel_delete_link
    then_the_channel_should_be_deleted
  end

  def and_i_am_on_a_channel_page
    VCR.use_cassette('avito/yozh_afrika') do
      visit channel_path @public_channel
    end
  end

  def when_i_click_on_delete_link
    click_link I18n.t('channels.show.destroy')
  end

  def when_i_click_on_the_channel_delete_link
    find("a[href^='#{channel_path @public_channel}'][data-method='delete']")
      .click
  end

  def then_i_should_be_on_the_index_page
    expect(current_path).to eq root_path
  end

  def and_i_should_see_success_message
    expect(page).to have_content I18n.t('flash.destroy.success')
  end

  def and_i_should_not_see_the_deleted_channel
    channels = page.all '.channels .channel-row-stripes'
    expect(channels.size).to eq 1
    expect(page).not_to have_content @public_channel.title
  end

  def then_the_channel_should_be_deleted
    then_i_should_be_on_the_index_page
    and_i_should_see_success_message
    and_i_should_not_see_the_deleted_channel
  end
end
