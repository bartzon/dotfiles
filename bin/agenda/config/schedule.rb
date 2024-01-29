# frozen_string_literal: true

env :PATH, ENV['PATH']
set :environment, 'development'
set :job_template, nil

every 10.minutes do
  command 'cd ~/.bin/agenda && bundle exec ruby agenda.rb fetch >/dev/null 2>&1'
end

every 1.minutes do
  command 'cd ~/.bin/agenda && bundle exec ruby agenda.rb parse >/dev/null 2>&1'
end
