namespace :messages_email do
  desc "This task sends email to all users who have new conversation notifications"
  task :send => :environment do
    users_hearted = User.all.select { |u| u.conversation_notifications.present? }
    users_hearted.each do |user|
      ConversationMailer.message_notification(user).deliver_later
      puts "Email is sent to #{user.email}"
    end
  end
end
