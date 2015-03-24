require 'rails_helper'

RSpec.feature 'list of channels' do
  before(:each) do
    given_there_are_public_and_private_channels
  end

  scenario 'on index page for anonymous user' do
    when_i_visit root_path
    then_i_should_see_the_list_of_public_channels
    and_i_should_not_see_the_private_channels
    and_i_should_not_see_channels_controls
  end

  scenario 'on index page for registered user' do
    given_i_am_an_authenticated_user :vasia
    when_i_visit root_path
    then_i_should_see_authored_channels_list
  end

  scenario 'on personal page for anonymous user' do
    when_i_visit channels_personal_path
    then_i_should_see_sign_up_form
  end

  scenario 'on personal page for registered user' do
    given_i_am_an_authenticated_user :vasia
    when_i_visit channels_personal_path
    then_i_should_see_authored_channels_list
  end

  scenario 'on all channels page for registered user' do
    given_i_am_an_authenticated_user :vasia
    when_i_visit channels_path
    then_i_should_see_the_list_of_public_channels
    and_i_should_not_see_other_users_private_channels
    and_i_should_see_controls_only_on_my_channels
  end

  # steps
  def then_i_should_see_the_list_of_public_channels
    channels = page.all '.channels .channel-row-stripes'
    expect(channels.size).to eq 2
    find_link @author_public_channel.title
    find_link @public_channel.title
  end

  def and_i_should_not_see_the_private_channels
    expect(page).not_to have_content @author_private_channel.title
    expect(page).not_to have_content @private_channel.title
  end

  def then_i_should_see_the_list_of_my_channels
    channels = page.all('.channels .channel-row-stripes')
    expect(channels.size).to eq @vasia.channels.count # 2
  end

  def and_i_should_not_see_other_users_private_channels
    expect(page).not_to have_content @private_channel.title
  end

  def then_i_should_see_sign_up_form
    expect(page).to have_css 'form#new_user'
  end

  # def then_i_should_see_the_list_of_public_and_my_channels
  #   channels = page.all('.channels .channel-row-stripes')
  #   expect(channels.size).to eq 3
  # end

  def all_controls
    all('.channel-row-stripes .actions a')
  end

  def and_i_should_not_see_channels_controls
    controls = all_controls
    expect(controls.size).to eq 0
  end

  def and_i_should_see_channels_controls
    controls = all_controls
    expect(controls.size).to eq @vasia.channels.count * 2 # 4
  end

  def and_i_should_see_controls_only_on_my_channels
    controls = all_controls
    expect(controls.size).to eq @vasia.channels.published.count * 2 # 2
  end

  def then_i_should_see_authored_channels_list # the owner's list
    then_i_should_see_the_list_of_my_channels
    and_i_should_not_see_other_users_private_channels
    and_i_should_see_channels_controls
  end
end
