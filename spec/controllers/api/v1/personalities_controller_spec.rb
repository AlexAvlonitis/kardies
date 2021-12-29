require 'rails_helper'

RSpec.describe Api::V1::PersonalitiesController, type: :controller do
  login_user

  let(:params_for_i) do
    { '2' => 'a', '6' => 'a', '11' => 'a', '15' => 'b',
      '19' => 'b', '22' => 'a', '27' => 'b', '32' => 'b' }
  end

  let(:params_for_s) do
    { '1' => 'b', '10' => 'b', '13' => 'a', '16' => 'a', '17' => 'a',
      '21' => 'a', '28' => 'b', '30' => 'b' }
  end

  let(:params_for_t) do
    { '3' => 'a', '5' => 'a', '12' => 'a', '14' => 'b', '20' => 'a',
      '24' => 'b', '25' => 'a', '29' => 'b' }
  end

  let(:params_for_j) do
    { '4' => 'a', '7' => 'a', '8' => 'b', '9' => 'a', '18' => 'b',
      '23' =>  'b', '26' => 'a', '31' => 'a' }
  end

  let(:istj_array) do
    [params_for_i, params_for_s, params_for_t, params_for_j]
  end
  let(:params) { istj_array.inject(&:merge) }

  describe 'POST #create' do
    before do
      allow(Personalities::Test).to receive(:call) { 'ISTJ' }
    end

    it "creates the personality results" do
      post :create, format: :json, params: params

      parsed_body = JSON.parse(response.body)
      expect(parsed_body['data']).to eq('ISTJ')
    end

    it "calls the personalities test library" do
      allow(Personalities::Test)
        .to receive(:call)
        .with(params)
        .and_return('ISTJ')

      post :create, format: :json, params: params
    end
  end
end
