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

  describe "GET /notes/:id #show" do
    context "when a note with that :id exists" do
      before(:each) do
        @note = FactoryGirl.create(:note)
        get :show, params: { id: @note.id }
      end

      it "returns the corresponding note" do
        expect(json_response['id']).to eq @note.id
        expect(json_response['title']).to eq @note.title
        expect(json_response['content']).to eq @note.content
      end

      it { expect(response.status).to eq 200 }
    end

    context "when no note with that :id exists" do
      before(:each) do
        get :show, params: { id: 1 }
      end

      it "renders an errors json" do
        expect(json_response['errors']).to_not be_nil
      end

      it { expect(response.status).to eq 404 }
    end
  end

  describe "GET /notes #index" do
    it "returns 3 notes" do
      FactoryGirl.create_list(:note, 3)
      get :index
      expect(json_response.count).to eq 3
    end

    it { expect(response.status).to eq 200 }
  end

  describe "POST /notes #create" do
    context "when is successfully created" do
      before(:each) do
        @note_attributes = FactoryGirl.attributes_for :note
        process :create, method: :post, params: { note: @note_attributes }
      end

      it "renders the json representation for the note record just created" do
        expect(json_response['title']).to eq @note_attributes[:title]
        expect(json_response['content']).to eq @note_attributes[:content]
      end

      it { expect(response.status).to eq 201 }
    end

    context "when is not created" do
      before(:each) do
        @invalid_note_attributes = { title_required: "to_create_note" }
        process :create, method: :post, params: { note: @invalid_note_attributes }
      end

      it "renders an errors json" do
        puts json_response
        expect(json_response['errors']).to_not be_nil
      end

      it "renders the json errors on why the user could not be created" do
        expect(json_response['errors']['title']).to_not be_nil
      end

      it { expect(response.status).to eq 422 }
    end
  end
end
