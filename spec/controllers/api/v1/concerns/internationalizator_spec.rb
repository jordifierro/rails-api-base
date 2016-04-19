require 'spec_helper'

module Api
  module V1
    describe Concerns::Internationalizator, type: :controller do
      controller(ApiController) do
        def fake_not_found
          raise ActiveRecord::RecordNotFound
        end
      end

      before do
        routes.draw { get 'fake_not_found' => 'api/v1/api#fake_not_found' }
      end

      it 'return english message when no locale' do
        signed_get :fake_not_found, nil
        expect(json_response['error']['message']).to eq I18n.t(
          'errors.messages.not_found', locale: I18n.default_locale)
        expect(json_response['error']['status']).to eq 404
      end

      it 'return english message when en locale' do
        request.env['HTTP_ACCEPT_LANGUAGE'] = 'en'
        signed_get :fake_not_found, nil
        expect(json_response['error']['message']).to eq I18n.t(
          'errors.messages.not_found', locale: :en)
        expect(json_response['error']['status']).to eq 404
      end

      it 'return spanish message when es locale' do
        request.env['HTTP_ACCEPT_LANGUAGE'] = 'es'
        signed_get :fake_not_found, nil
        expect(json_response['error']['message']).to eq I18n.t(
          'errors.messages.not_found', locale: :es)
        expect(json_response['error']['status']).to eq 404
      end

      it 'return english message when unknown locale' do
        request.env['HTTP_ACCEPT_LANGUAGE'] = 'wk'
        signed_get :fake_not_found, nil
        expect(json_response['error']['message']).to eq I18n.t(
          'errors.messages.not_found', locale: I18n.default_locale)
        expect(json_response['error']['status']).to eq 404
      end
    end
  end
end
