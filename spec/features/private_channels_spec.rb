require 'rails_helper'

RSpec.feature 'hide channels' do
  before(:each) do
    given_there_are_public_and_private_channels
    given_i_am_an_authenticated_user :vasia
  end

  scenario 'private channels are not visible for other users' do
    when_i_visit channels_path
    then_i_should_see_the_list_of_public_channels
    and_i_should_not_see_other_users_private_channels
  end

  scenario 'private channels are visible for the author' do
    when_i_visit channels_personal_path
    then_i_should_see_my_private_channels
    and_i_should_not_see_other_users_private_channels
  end

  scenario 'mark a public channel as private' do
    and_i_am_on edit_channel_path @author_public_channel
    when_i_mark_the_channel_as :private
    # then_i_should_see_it_in_the_list_of :public_channels
    then_i_should_not_see_it_in_the_public_channels_list
  end

  scenario 'mark a private channel as public' do
    and_i_am_on edit_channel_path @author_private_channel
    when_i_mark_the_channel_as :public
    then_i_should_see_it_in_the_public_channels_list
  end

  scenario 'toggle a channel visibility' do
    and_i_am_on channel_path @author_private_channel
    when_i_click_on_toggle_visibility_link
    then_i_should_see_it_in_the_public_channels_list
  end

  def then_i_should_see_the_list_of_public_channels
    channels = page.all '.channels .channel-row-stripes'
    expect(channels.size).to eq 2
    find_link @author_public_channel.title
    find_link @public_channel.title
  end

  def and_i_should_not_see_other_users_private_channels
    expect(page).not_to have_content @private_channel.title
  end

  def then_i_should_see_my_private_channels # the owner's list
    expect(page).to have_content @author_private_channel.title
  end

  def when_i_mark_the_channel_as published
    if published == :private
      uncheck 'channel_public'
    else
      check 'channel_public'
    end
    find('[type="submit"]').click
  end

  def then_i_should_not_see_it_in_the_public_channels_list
    visit channels_path
    expect(page).not_to have_content @author_private_channel.title
  end

  def then_i_should_see_it_in_the_public_channels_list
    visit channels_path
    expect(page).to have_content @author_private_channel.title
  end

  def when_i_click_on_toggle_visibility_link
    url = toggle_public_channel_path @author_private_channel
    find("a[href='#{url}'][data-method='patch']").click
  end
end
