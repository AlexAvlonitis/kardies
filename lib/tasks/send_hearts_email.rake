namespace :hearts_email do
  desc "This task sends email to all users who have hearts records notifications"
  task :send => :environment do
    users_hearted = User.all.select { |u| u.vote_notifications.present? }
    users_hearted.each do |user|
      HeartsMailer.new_hearts_notification(user).deliver
      puts "Email is sent to #{user.email}"
    end
  end
end
