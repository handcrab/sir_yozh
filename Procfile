web: rvm use 2.1.5 do bundle exec unicorn_rails -Dc /etc/unicorn/yozh-delovoy.handcrab.rb
worker: RAILS_ENV=production rvm use 2.1.5 do bundle exec bin/delayed_job start
scheduler: RAILS_ENV=production rvm use 2.1.5 do bundle exec clockworkd -c clock.rb start