# http://www.esf.edu/for/germain/Self%20Eval.%20Personality%20Type.pdf

module Personalities
  class ScoreCalculator
    def initialize(params)
      @params = params
      @score_for_i = 0
      @score_for_e = 0
      @score_for_s = 0
      @score_for_t = 0
      @score_for_f = 0
      @score_for_n = 0
      @score_for_j = 0
      @score_for_p = 0
      @result = ''
    end

    def execute
      calculate
    end

    private

    attr_reader :params

    def calculate
      result_for_i_or_e
      result_for_s_or_n
      result_for_t_or_f
      result_for_j_or_p
      @result
    end

    def result_for_i_or_e
      calculate_i
      calculate_e
      @score_for_i > @score_for_e ? add_result('I') : add_result('E')
    end

    def result_for_s_or_n
      calculate_s
      calculate_n
      @score_for_n > @score_for_s ? add_result('N') : add_result('S')
    end

    def result_for_t_or_f
      calculate_t
      calculate_f
      @score_for_t > @score_for_f ? add_result('T') : add_result('F')
    end

    def result_for_j_or_p
      calculate_j
      calculate_p
      @score_for_j > @score_for_p ? add_result('J') : add_result('P')
    end

    def calculate_i
      matches_for_i.each { |n, v| @score_for_i += 1 if params[n] == v }
    end

    def calculate_e
      matches_for_e.each { |n, v| @score_for_e += 1 if params[n] == v }
    end

    def calculate_s
      matches_for_s.each { |n, v| @score_for_s += 1 if params[n] == v }
    end

    def calculate_n
      matches_for_n.each { |n, v| @score_for_n += 1 if params[n] == v }
    end

    def calculate_t
      matches_for_t.each { |n, v| @score_for_t += 1 if params[n] == v }
    end

    def calculate_f
      matches_for_f.each { |n, v| @score_for_f += 1 if params[n] == v }
    end

    def calculate_j
      matches_for_j.each { |n, v| @score_for_j += 1 if params[n] == v }
    end

    def calculate_p
      matches_for_p.each { |n, v| @score_for_p += 1 if params[n] == v }
    end

    def matches_for_i
      { '2' => 'a', '6' => 'a', '11' => 'a', '15' => 'b',
        '19' => 'b', '22' => 'a', '27' => 'b', '32' => 'b' }
    end

    def matches_for_e
      { '2' => 'b', '6' => 'b', '11' => 'b', '15' => 'a',
        '19' => 'a', '22' => 'b', '27' => 'a', '32' => 'a' }
    end

    def matches_for_s
      { '1' => 'b', '10' => 'b', '13' => 'a', '16' => 'a', '17' => 'a',
        '21' => 'a', '28' => 'b', '30' => 'b' }
    end

    def matches_for_n
      { '1' => 'a', '10' => 'c', '13' => 'b', '16' => 'b', '17' => 'b',
        '21' => 'b', '28' => 'a', '30' => 'a' }
    end

    def matches_for_t
      { '3' => 'a', '5' => 'a', '12' => 'a', '14' => 'b', '20' => 'a',
        '24' => 'b', '25' => 'a', '29' => 'b' }
    end

    def matches_for_f
      { '3' => 'b', '5' => 'b', '12' => 'b', '14' => 'a', '20' => 'b',
        '24' => 'a', '25' => 'b', '29' => 'a' }
    end

    def matches_for_j
      { '4' => 'a', '7' => 'a', '8' => 'b', '9' => 'a', '18' => 'b',
        '23' =>  'b', '26' => 'a', '31' => 'a' }
    end

    def matches_for_p
      { '4' => 'b', '7' => 'b', '8' => 'a', '9' => 'b', '18' => 'a',
        '23' =>  'a', '26' => 'b', '31' => 'b' }
    end

    def add_result(letter)
      @result << letter
    end
  end
end
