require 'spec_helper'

describe Api::V1::Concerns::ErrorHandler, type: :controller do
  controller(Api::V1::ApiController) do
    def fake_not_found
      User.find(1)
    end
  end

  before { routes.draw { get 'fake_not_found' => 'anonymous#fake_not_found' } }

  context 'when record not found triggered' do
    before { signed_get :fake_not_found, nil }

    it { expect(json_response['errors']['not_found']).to eq I18n.t('error.messages.not_found')}
    it { expect(response.status).to eq 404 }
  end
end
