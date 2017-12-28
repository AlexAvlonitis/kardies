module Validators
  class BlackListValidator < ActiveModel::Validator
    def validate(record)
      return unless record && record.try(:email)

      black_list = BlockedEmail.all
      b_email = black_list.map(&:email)
      b_domain = black_list.map(&:domain)

      if email_black_listed?(b_domain, b_email, record.email)
        record.errors[:email] << 'Ο λογαριασμός έχει αποκλειστεί'
      end
    end

    private

    def email_black_listed?(b_domain, b_email, email)
      b_domain.include?(exctracted_domain(email)) || b_email.include?(email)
    end

    def exctracted_domain(email)
      email.scan(/(?=\@).*$/).last
    end
  end
end
