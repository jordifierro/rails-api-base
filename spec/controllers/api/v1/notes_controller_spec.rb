require 'spec_helper'

describe Api::V1::NotesController, type: :controller do
  let(:user) { create :user }
  let(:note) { create :note, user: user }
  before(:each) do
    request.headers['Accept'] = 'application/vnd.railsapibase.v1'
    sign_in_user user
  end

  it 'routes correctly' do
    expect(get: '/notes').to route_to('api/v1/notes#index', format: :json)
    expect(post: '/notes').to route_to('api/v1/notes#create', format: :json)
    expect(get: '/notes/1').to route_to(
      'api/v1/notes#show', id: '1', format: :json)
    expect(patch: '/notes/2').to route_to(
      'api/v1/notes#update', id: '2', format: :json)
    expect(put: '/notes/3').to route_to(
      'api/v1/notes#update', id: '3', format: :json)
    expect(delete: '/notes/4').to route_to(
      'api/v1/notes#destroy', id: '4', format: :json)
  end

  describe 'GET /notes/:id #show' do
    context 'when note exists' do
      before(:each) { signed_get :show, params: { id: note.id } }

      it 'returns the resource' do
        expect(json_response['id']).to eq note.id
        expect(json_response['title']).to eq note.title
        expect(json_response['content']).to eq note.content
        expect(json_response.key?('user_id')).to be false
        expect(json_response.key?('created_at')).to be false
        expect(json_response.key?('updated_at')).to be false
      end

      it { expect(response.status).to eq 200 }
    end

    context 'when note doesn\'t exist' do
      before(:each) { signed_get :show, params: { id: 1 } }

      it 'renders errors' do
        expect(json_response['error']).to_not be_nil
        expect(json_response['error']['status']).to eq 404
        expect(json_response['error']['message']).to_not be_nil
      end

      it { expect(response.status).to eq 404 }
    end
  end

  describe 'GET /notes #index' do
    it 'returns some notes' do
      create_list(:note, 3, user: user)
      signed_get :index, nil
      expect(json_response.count).to eq 3
    end

    it { expect(response.status).to eq 200 }
  end

  describe 'POST /notes #create' do
    context 'when is created' do
      before(:each) do
        @note_attr = attributes_for :note
        @note_attr[:user_id] = user.id
        signed_post :create, params: { note: @note_attr }
      end

      it 'renders resource created' do
        expect(json_response['title']).to eq @note_attr[:title]
        expect(json_response['content']).to eq @note_attr[:content]
      end

      it { expect(response.status).to eq 201 }
    end

    context 'when is not created' do
      before(:each) do
        @invalid_attr = { title_required: 'to_create_note', user_id: user.id }
        signed_post :create, params: { note: @invalid_attr }
      end

      it 'renders errors' do
        expect(json_response['error']).to_not be_nil
        expect(json_response['error']['status']).to eq 422
        expect(json_response['error']['message']).to_not be_nil
      end

      it { expect(response.status).to eq 422 }
    end
  end

  describe 'PUT /notes/:id #update' do
    context 'when is updated' do
      before(:each) do
        @update_attr = attributes_for :note
        signed_put :update, params: { id: note.id, note: @update_attr }
      end

      it 'renders resource updated' do
        expect(json_response['title']).to eq @update_attr[:title]
        expect(json_response['content']).to eq @update_attr[:content]
      end

      it { expect(response.status).to eq 200 }
    end

    context 'when is not updated' do
      before(:each) do
        @invalid_attr = { title: '' }
        signed_put :update, params: { id: note.id, note: @invalid_attr }
      end

      it 'doesn\'t modify the note' do
        actual_note = Note.find(note.id)
        expect(actual_note.title).to eq note.title
        expect(actual_note.title).to_not eq @invalid_attr[:title]
      end

      it 'renders errors' do
        expect(json_response['error']).to_not be_nil
        expect(json_response['error']['status']).to eq 422
        expect(json_response['error']['message']).to_not be_nil
      end

      it { expect(response.status).to eq 422 }
    end

    context 'when is not found' do
      before(:each) do
        signed_put :update, params: { id: 1 }
      end

      it 'renders errors' do
        expect(json_response['error']).to_not be_nil
        expect(json_response['error']['status']).to eq 404
        expect(json_response['error']['message']).to_not be_nil
      end

      it { expect(response.status).to eq 404 }
    end
  end

  describe 'DELETE /notes/:id #destroy' do
    context 'when is deleted' do
      before(:each) { signed_delete :destroy, params: { id: note.id } }

      it 'cannot be found anymore' do
        expect do
          Note.find(note.id)
        end.to raise_error(ActiveRecord::RecordNotFound)
      end

      it { expect(response.status).to eq 204 }
    end

    context 'when doesn\'t exists' do
      before(:each) { signed_delete :destroy, params: { id: 1 } }

      it 'renders errors' do
        expect(json_response['error']).to_not be_nil
        expect(json_response['error']['status']).to eq 404
        expect(json_response['error']['message']).to_not be_nil
      end

      it { expect(response.status).to eq 404 }
    end
  end
end
