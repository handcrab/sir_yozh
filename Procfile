web: rvm use 2.1.5 do bundle exec unicorn_rails -Dc /etc/unicorn/yozh-delovoy.handcrab.rb
worker: rvm use 2.1.5 do bundle exec bin/delayed_job start
scheduler: rvm use 2.1.5 do bundle exec clockworkd -c clock.rb start