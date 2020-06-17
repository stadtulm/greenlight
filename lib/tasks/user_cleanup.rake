# frozen_string_literal: true

require 'bigbluebutton_api'

namespace :user do
  desc "permanently destroys users that have been pending >=14 days or have been denied/deleted" 
  task :cleanup => :environment do |_task, args|
    User.deleted.each do |us|
      us.destroy(true)
    end
    puts "removed deleted users"
    User.with_role(:pending).where(  'users.created_at <= ?', Time.now - 14.days).each do |us|
      us.destroy(true)
    end
    puts "removed pending users older than 14 days"
    User.with_role(:denied).each do |us|
      us.destroy(true)
    end
    puts "removed denied users"
  end
end
