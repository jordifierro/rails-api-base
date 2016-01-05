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

      it "renders the json errors on why the user could not be found" do
        expect(json_response['errors']['not_found']).to_not be_nil
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
        @note_attr = FactoryGirl.attributes_for :note
        process :create, method: :post, params: { note: @note_attr }
      end

      it "renders the json representation for the note record just created" do
        expect(json_response['title']).to eq @note_attr[:title]
        expect(json_response['content']).to eq @note_attr[:content]
      end

      it { expect(response.status).to eq 201 }
    end

    context "when is not created" do
      before(:each) do
        @invalid_attr = { title_required: "to_create_note" }
        process :create, method: :post, params: { note: @invalid_attr }
      end

      it "renders an errors json" do
        expect(json_response['errors']).to_not be_nil
      end

      it "renders the json errors on why the user could not be created" do
        expect(json_response['errors']['title']).to_not be_nil
      end

      it { expect(response.status).to eq 422 }
    end
  end

  describe "PUT /notes/:id #update" do
    context "when is successfully updated" do
      before(:each) do
        original_note = FactoryGirl.create(:note)
        @update_attr = FactoryGirl.attributes_for :note
        process :update, method: :put, params: { id: original_note.id, note: @update_attr }
      end

      it "renders the json representation for the note record just updated" do
        expect(json_response['title']).to eq @update_attr[:title]
        expect(json_response['content']).to eq @update_attr[:content]
      end

      it { expect(response.status).to eq 200 }
    end

    context "when attributes are wrong" do
      before(:each) do
        @original_note = FactoryGirl.create(:note)
        @invalid_attr = { title: "" }
        process :update, method: :put, params: { id: @original_note.id, note: @invalid_attr }
      end

      it "doesn't modify the note" do
        actual_note = Note.find(@original_note.id)
        expect(actual_note.title).to eq @original_note.title
        expect(actual_note.title).to_not eq @invalid_attr[:title]
      end

      it "renders an errors json" do
        expect(json_response['errors']).to_not be_nil
      end

      it "renders the json errors on why the user could not be updated" do
        expect(json_response['errors']['title']).to_not be_nil
      end

      it { expect(response.status).to eq 422 }
    end

    context "when note with :id not found" do
      before(:each) do
        process :update, method: :put, params: { id: 1 }
      end

      it "renders an errors json" do
        expect(json_response['errors']).to_not be_nil
      end

      it "renders the json errors on why the user could not be updated" do
        expect(json_response['errors']['not_found']).to_not be_nil
      end

      it { expect(response.status).to eq 404 }
    end
  end

  describe "DELETE /notes/:id #destroy" do
    context "when note with :id exists" do
      before(:each) do
        @note = FactoryGirl.create(:note)
        process :destroy, method: :delete, params: { id: @note.id }
      end

      it "cannot be found anymore" do
        expect{ Note.find(@note.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it { expect(response.status).to eq 204 }
    end

    context "when note with :id doesn't exists" do
      before(:each) do
        process :destroy, method: :delete, params: { id: 1 }
      end

      it "renders an errors json" do
        expect(json_response['errors']).to_not be_nil
      end

      it "renders the json errors on why the user could not be updated" do
        expect(json_response['errors']['not_found']).to_not be_nil
      end

      it { expect(response.status).to eq 404 }
    end
  end
end
