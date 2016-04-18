require 'spec_helper'

RSpec.configure do |config|
  config.render_views = true
end

describe PagesController do
  it 'routes correctly' do
    expect(get: '/privacy').to route_to('pages#privacy')
    expect(get: '/terms').to route_to('pages#terms')
  end

  describe 'GET /privacy' do
    it 'renders pages/privacy view' do
      get :privacy
      expect(response.body).to render_template('pages/privacy')
    end
  end

  describe 'GET /terms' do
    it 'renders pages/terms view' do
      get :terms
      expect(response.body).to render_template('pages/terms')
    end
  end
end
