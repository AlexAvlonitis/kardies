require 'rails_helper'

RSpec.describe Personalities::ScoreCalculator do
  subject { described_class.new(params) }

  let(:params) { {} }

  let(:params_for_i) do
    { '2' => 'a', '6' => 'a', '11' => 'a', '15' => 'b',
      '19' => 'b', '22' => 'a', '27' => 'b', '32' => 'b' }
  end

  let(:params_for_e) do
    { '2' => 'b', '6' => 'b', '11' => 'b', '15' => 'a',
      '19' => 'a', '22' => 'b', '27' => 'a', '32' => 'a' }
  end

  let(:params_for_s) do
    { '1' => 'b', '10' => 'b', '13' => 'a', '16' => 'a', '17' => 'a',
      '21' => 'a', '28' => 'b', '30' => 'b' }
  end

  let(:params_for_n) do
    { '1' => 'a', '10' => 'c', '13' => 'b', '16' => 'b', '17' => 'b',
      '21' => 'b', '28' => 'a', '30' => 'a' }
  end

  let(:params_for_t) do
    { '3' => 'a', '5' => 'a', '12' => 'a', '14' => 'b', '20' => 'a',
      '24' => 'b', '25' => 'a', '29' => 'b' }
  end

  let(:params_for_f) do
    { '3' => 'b', '5' => 'b', '12' => 'b', '14' => 'a', '20' => 'b',
      '24' => 'a', '25' => 'b', '29' => 'a' }
  end

  let(:params_for_j) do
    { '4' => 'a', '7' => 'a', '8' => 'b', '9' => 'a', '18' => 'b',
      '23' =>  'b', '26' => 'a', '31' => 'a' }
  end

  let(:params_for_p) do
    { '4' => 'b', '7' => 'b', '8' => 'a', '9' => 'b', '18' => 'a',
      '23' =>  'a', '26' => 'b', '31' => 'b' }
  end

  describe '#execute' do
    context 'When params should result ISTJ' do
      let(:istj_array) do
        [params_for_i, params_for_s, params_for_t, params_for_j]
      end
      let(:params) { istj_array.inject(&:merge) }

      it 'returns ISTJ' do
        expect(subject.execute).to eq 'ISTJ'
      end
    end

    context 'When params should result ISFJ' do
      let(:isfj_array) do
        [params_for_i, params_for_s, params_for_f, params_for_j]
      end
      let(:params) { isfj_array.inject(&:merge) }

      it 'returns ISFJ' do
        expect(subject.execute).to eq 'ISFJ'
      end
    end

    context 'When params should result INFJ' do
      let(:infj_array) do
        [params_for_i, params_for_n, params_for_f, params_for_j]
      end
      let(:params) { infj_array.inject(&:merge) }

      it 'returns INFJ' do
        expect(subject.execute).to eq 'INFJ'
      end
    end

    context 'When params should result INTJ' do
      let(:intj_array) do
        [params_for_i, params_for_n, params_for_t, params_for_j]
      end
      let(:params) { intj_array.inject(&:merge) }

      it 'returns INTJ' do
        expect(subject.execute).to eq 'INTJ'
      end
    end

    context 'When params should result ISTP' do
      let(:istp_array) do
        [params_for_i, params_for_s, params_for_t, params_for_p]
      end
      let(:params) { istp_array.inject(&:merge) }

      it 'returns ISTP' do
        expect(subject.execute).to eq 'ISTP'
      end
    end

    context 'When params should result ISFP' do
      let(:isfp_array) do
        [params_for_i, params_for_s, params_for_f, params_for_p]
      end
      let(:params) { isfp_array.inject(&:merge) }

      it 'returns ISFP' do
        expect(subject.execute).to eq 'ISFP'
      end
    end

    context 'When params should result INFP' do
      let(:infp_array) do
        [params_for_i, params_for_n, params_for_f, params_for_p]
      end
      let(:params) { infp_array.inject(&:merge) }

      it 'returns INFP' do
        expect(subject.execute).to eq 'INFP'
      end
    end

    context 'When params should result INTP' do
      let(:intp_array) do
        [params_for_i, params_for_n, params_for_t, params_for_p]
      end
      let(:params) { intp_array.inject(&:merge) }

      it 'returns INTP' do
        expect(subject.execute).to eq 'INTP'
      end
    end

    context 'When params should result ESTP' do
      let(:estp_array) do
        [params_for_e, params_for_s, params_for_t, params_for_p]
      end
      let(:params) { estp_array.inject(&:merge) }

      it 'returns ESTP' do
        expect(subject.execute).to eq 'ESTP'
      end
    end

    context 'When params should result ESFP' do
      let(:esfp_array) do
        [params_for_e, params_for_s, params_for_f, params_for_p]
      end
      let(:params) { esfp_array.inject(&:merge) }

      it 'returns ESFP' do
        expect(subject.execute).to eq 'ESFP'
      end
    end

    context 'When params should result ENFP' do
      let(:enfp_array) do
        [params_for_e, params_for_n, params_for_f, params_for_p]
      end
      let(:params) { enfp_array.inject(&:merge) }

      it 'returns ENFP' do
        expect(subject.execute).to eq 'ENFP'
      end
    end

    context 'When params should result ENTP' do
      let(:entp_array) do
        [params_for_e, params_for_n, params_for_t, params_for_p]
      end
      let(:params) { entp_array.inject(&:merge) }

      it 'returns ENTP' do
        expect(subject.execute).to eq 'ENTP'
      end
    end

    context 'When params should result ESTJ' do
      let(:estj_array) do
        [params_for_e, params_for_s, params_for_t, params_for_j]
      end
      let(:params) { estj_array.inject(&:merge) }

      it 'returns ESTJ' do
        expect(subject.execute).to eq 'ESTJ'
      end
    end

    context 'When params should result ESFJ' do
      let(:esfj_array) do
        [params_for_e, params_for_s, params_for_f, params_for_j]
      end
      let(:params) { esfj_array.inject(&:merge) }

      it 'returns ESFJ' do
        expect(subject.execute).to eq 'ESFJ'
      end
    end

    context 'When params should result ENFJ' do
      let(:enfj_array) do
        [params_for_e, params_for_n, params_for_f, params_for_j]
      end
      let(:params) { enfj_array.inject(&:merge) }

      it 'returns ENFJ' do
        expect(subject.execute).to eq 'ENFJ'
      end
    end

    context 'When params should result ENTJ' do
      let(:entj_array) do
        [params_for_e, params_for_n, params_for_t, params_for_j]
      end
      let(:params) { entj_array.inject(&:merge) }

      it 'returns ENTJ' do
        expect(subject.execute).to eq 'ENTJ'
      end
    end
  end
end
