require 'rails_helper'

RSpec.describe Api::V1::MembershipsController, type: :controller do
  login_user

  let(:subscription) { { id: 1, expiry_date: '2020-1-1' } }
  let(:params) do
    {
      payment_method: "card",
      payment_plan: "monthly",
      idempotency_key: 'random_key'
    }
  end

  [
    [Memberships::UpdateMembershipService, 'store_membership', :post],
    [Memberships::GetMembershipService, 'retrieve_membership', :get],
    [Memberships::CancelMembershipService, 'destroy', :delete]
  ].each do |service, method, action|
    describe "#{action.to_s.upcase} ##{method}" do
      before do
        allow(service).to receive(:call) { subscription }
      end

      context 'when the request is successful' do
        it 'returns the subscription' do
          public_send(action, method.to_sym)

          assert_response :success
          parsed_body = JSON.parse(response.body)
          expect(parsed_body).to eq(subscription.with_indifferent_access)
        end

        it "calls the #{service.to_s} service" do
          expect(service).to receive(:call).with(@user)

          public_send(action, method.to_sym)
        end
      end

      context 'when the request raises an errors' do
        before do
          allow(service)
            .to receive(:call)
            .and_raise(StandardError.new('any error message'))
        end

        it 'returns the error' do
          public_send(action, method.to_sym)

          assert_response :unprocessable_entity
          parsed_body = JSON.parse(response.body)
          expect(parsed_body).to eq({ 'errors' => 'any error message' })
        end
      end
    end
  end
end
