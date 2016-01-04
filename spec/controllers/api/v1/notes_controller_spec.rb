require 'spec_helper'

describe Api::V1::NotesController, type: :controller do

  it "routes correctly" do
    expect(get: "/notes").to route_to("api/v1/notes#index", format: :json)
    expect(post: "/notes").to route_to("api/v1/notes#create", format: :json)
    expect(get: "/notes/1").to route_to("api/v1/notes#show", id: "1", format: :json)
    expect(patch: "/notes/2").to route_to("api/v1/notes#update", id: "2", format: :json)
    expect(put: "/notes/3").to route_to("api/v1/notes#update", id: "3", format: :json)
    expect(delete: "/notes/4").to route_to("api/v1/notes#destroy", id: "4", format: :json)
  end

  describe 'GET /notes/:id' do

    it 'returns a note by :id' do
      note = FactoryGirl.create(:note)
      get :show, params: { id: note.id }
      expect(json_response["id"]).to eq note.id
      expect(json_response["title"]).to eq note.title
      expect(json_response["content"]).to eq note.content
    end

    it 'returns 200 when note with :id exists' do
      note = FactoryGirl.create(:note)
      get :show, params: { id: note.id }
      expect(response.status).to eq 200
    end

    it 'returns 404 when note with :id doesnt exists' do
      get :show, params: { id: 1 }
      expect(response.status).to eq 404
    end

  end

end
