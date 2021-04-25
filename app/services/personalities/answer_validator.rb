module Personalities
  class AnswerValidator
    def initialize(params)
      @params = params
    end

    def validate
      all_answers_exist?
    end

    private

    attr_reader :params

    def all_answers_exist?
      (1..32).each do |n|
        raise "Δεν απαντήσατε την ερώτηση #{n}" unless params.key?(n.to_s)
        raise 'Λάθος απάντηση!' unless correct_values?(n.to_s)
      end
    end

    def correct_values?(key)
      params[key] == 'a' || params[key] == 'b'
    end
  end
end
