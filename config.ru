# This file is used by Rack-based servers to start the application.

if Rails.env.production?
  DelayedJobWeb.use Rack::Auth::Basic do |username, password|
    username == 'admin' && password == 'admin'
  end
end

require ::File.expand_path('../config/environment', __FILE__)
run Rails.application
