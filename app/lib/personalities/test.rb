module Personalities
  class Test
    def self.call(params = {})
      new(
        params,
        Personalities::AnswerValidator.new(params),
        Personalities::ScoreCalculator.new(params)
      ).call
    end

    def initialize(params, answer_validator, score_calculator)
      @params = params
      @answer_validator = answer_validator
      @score_calculator = score_calculator
    end

    def call
      validate_params
      calculate_score
    end

    private

    attr_reader :params, :answer_validator, :score_calculator

    def validate_params
      answer_validator.validate
    end

    def calculate_score
      score_calculator.execute
    end
  end
end
