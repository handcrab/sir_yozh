module Features
  module Helpers
    def given_there_are_public_and_private_channels
      @vasia = create :vasia
      @hodor = create :hodor
      @author_public_channel = create :public_channel
      @author_private_channel = create :private_channel
      @public_channel = create :public_channel_ext
      @private_channel = create :private_channel_ext

      @vasia.channels.push @author_public_channel, @author_private_channel
      @hodor.channels.push @public_channel, @private_channel
    end

    def when_i_visit url
      visit url
    end
    alias_method :and_i_am_on, :when_i_visit

    def and_i_am_an_authenticated_user username
      visit root_path
      user = attributes_for username
      click_link I18n.t('layouts.application.menu.sign_in'), match: :first

      fill_in 'user_email', with: user[:email]
      fill_in 'user_password', with: user[:password]
      find('[type="submit"]').click
    end

    alias_method :given_i_am_an_authenticated_user,
                 :and_i_am_an_authenticated_user

  end
end
