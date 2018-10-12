module Recaptcha
  class Client
    include HTTParty
    RECAPTCHA_URL = 'https://www.google.com/recaptcha/api/siteverify'

    def validate(recaptcha_value)
      response = request(params.merge({'response' => recaptcha_value}))

      return_response(response)
    end

    private

    def params
      { 'secret' => ENV['RECAPTCHA_SECRET_KEY'] }
    end

    def request(params)
      self.class.post(RECAPTCHA_URL, body: params)
    rescue HTTParty::Error, StandardError => _e
      nil
    end

    def return_response(response)
      response&.success? ? response['success'] : nil
    end
  end
end