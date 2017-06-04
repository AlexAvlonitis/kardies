class ConversationMailer < ApplicationMailer

  def message_notification(user)
    attachments.inline['hearts_2.png'] = File.read('public/images/hearts_2.png')

    @user = user
    mail( to: "#{@user.email}",
          subject: "Έχετε νέο μήνυμα #{@user.username}! Kardies.gr")
  end
end
