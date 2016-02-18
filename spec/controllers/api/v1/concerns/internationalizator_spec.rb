require 'spec_helper'

describe Api::V1::Concerns::Internationalizator, type: :controller do
  controller(Api::V1::ApiController) do
    def fake_not_found
      raise ActiveRecord::RecordNotFound
    end
  end

  before { routes.draw { get 'fake_not_found' => 'anonymous#fake_not_found' } }

  it "return english message when no locale" do
    signed_get :fake_not_found, nil
    expect(json_response['errors']['not_found']).to eq I18n.t('errors.messages.not_found', locale: :en)
  end

  it "return english message when en locale" do
    request.env['HTTP_ACCEPT_LANGUAGE'] = 'en'
    signed_get :fake_not_found, nil
    expect(json_response['errors']['not_found']).to eq I18n.t('errors.messages.not_found', locale: :en)
  end

  it "return spanish message when es locale" do
    request.env['HTTP_ACCEPT_LANGUAGE'] = 'es'
    signed_get :fake_not_found, nil
    expect(json_response['errors']['not_found']).to eq I18n.t('errors.messages.not_found', locale: :es)
  end

  it "return english message when unknown locale" do
    request.env['HTTP_ACCEPT_LANGUAGE'] = 'wk'
    signed_get :fake_not_found, nil
    expect(json_response['errors']['not_found']).to eq I18n.t('errors.messages.not_found', locale: :en)
  end
end
