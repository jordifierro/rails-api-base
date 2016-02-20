require 'spec_helper'

module Api::V1
  describe Concerns::ErrorHandler, type: :controller do
    controller(ApiController) do
      def fake_not_found
        raise ActiveRecord::RecordNotFound
      end
    end

    before { routes.draw { get 'fake_not_found' => 'api/v1/api#fake_not_found' } }

    context "when record not found triggered" do
      before { signed_get :fake_not_found, nil }

      it { expect(json_response['errors'][0]['message']).to eq I18n.t(
                                                    'errors.messages.not_found') }
      it { expect(response.status).to eq 404 }
    end
  end
end
