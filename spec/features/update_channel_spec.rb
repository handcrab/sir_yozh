require 'rails_helper'

RSpec.feature 'update channel' do
  before(:each) do
    given_there_are_public_and_private_channels
    given_i_am_an_authenticated_user :hodor
  end

  scenario 'as author from show page' do
    and_i_am_on channel_path @public_channel
    when_i_click_on_update_link
    and_i_fill_in_the_form_with_valid_data
    then_the_channel_should_be_updated
  end

  scenario 'as author from index page' do
    given_i_am_on root_path
    when_i_click_on_the_channel_update_link
    and_i_fill_in_the_form_with_valid_data
    then_the_channel_should_be_updated
  end

  def when_i_click_on_update_link
    click_link I18n.t('channels.show.edit')
  end

  def when_i_click_on_the_channel_update_link
    find("a[href='#{edit_channel_path @public_channel}']").click
  end

  def and_i_fill_in_the_form_with_valid_data
    expect(page).to have_css 'form.edit_channel'

    @updated_channel = attributes_for :new_channel
    fill_in 'channel_title', with: @updated_channel[:title]
    # fill_in 'channel_source_url', with: @channel[:source_url]
    find('[type="submit"]').click
  end

  def then_i_should_be_on_the_channel_page
    expect(current_path).to eq channel_path @public_channel
  end

  # def and_i_should_see_success_message
  #   expect(page).to have_content I18n.t('flash.update.success')
  # end

  def then_the_channel_should_be_updated
    then_i_should_be_on_the_channel_page
    # and_i_should_see_success_message
    expect(page).to have_content @updated_channel[:title]
    expect(page).not_to have_content @public_channel.title
  end
end
