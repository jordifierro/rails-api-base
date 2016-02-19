require 'spec_helper'

describe Api::V1::UsersController do
  let(:user) { create :user }
  let(:user_attr) { attributes_for :user }
  before(:each) do
    ENV['SECRET_API_KEY'] = nil
    request.headers['Accept'] = "application/vnd.railsapibase.v1"
  end

  it "routes correctly" do
    expect(post: "/users").to route_to("api/v1/users#create", format: :json)
    expect(delete: "/users/1").to route_to("api/v1/users#destroy",
                                                        id: "1", format: :json)
  end

  describe "POST /users #create" do
    context "when is created without api_key" do
      before(:each) { post :create, params: { user: user_attr } }

      it "renders resource created" do
        expect(json_response['id']).to_not be_nil
        expect(json_response['email']).to eq user_attr[:email]
        expect(json_response['password']).to be_nil
        expect(json_response['auth_token']).to_not be_nil
      end

      it { expect(response.status).to eq 201 }
    end

    context "when is created with api_key" do
      before(:each) do
        ENV['SECRET_API_KEY'] = "SECRET_API_KEY"
        request.headers["Authorization"] = "SECRET_API_KEY"
        post :create, params: { user: user_attr }
      end

      it "renders resource created" do
        expect(json_response['id']).to_not be_nil
        expect(json_response['email']).to eq user_attr[:email]
        expect(json_response['password']).to be_nil
        expect(json_response['auth_token']).to_not be_nil
      end

      it { expect(response.status).to eq 201 }
    end

    context "is not created" do
      it "without email attr" do
        user_attr[:email] = nil
        post :create, params: { user: user_attr }
        expect(json_response['errors']).to_not be_nil
        expect(json_response['errors']['email']).to_not be_nil
      end

      it "with invalid email" do
        user_attr[:email] = "invalid@email"
        post :create, params: { user: user_attr }
        expect(json_response['errors']).to_not be_nil
        expect(json_response['errors']['email']).to_not be_nil
      end

      it "with repeated email" do
        post :create, params: { user: user_attr }
        post :create, params: { user: user_attr }
        expect(json_response['errors']).to_not be_nil
        expect(json_response['errors']['email']).to_not be_nil
      end

      it "with short password" do
        user_attr[:password] = "1234"
        user_attr[:password_confirmation] = "1234"
        post :create, params: { user: user_attr }
        expect(json_response['errors']).to_not be_nil
        expect(json_response['errors']['password']).to_not be_nil
      end

      it "with wrong password confirmation" do
        user_attr[:password] = "one_password"
        user_attr[:password_confirmation] = "another_password"
        post :create, params: { user: user_attr }
        expect(json_response['errors']).to_not be_nil
        expect(json_response['errors']['password_confirmation']).to_not be_nil
      end

      it "and returns 422" do
        user_attr[:email] = nil
        post :create, params: { user: user_attr }
        expect(response.status).to eq 422
      end
    end
  end

  context "is not created because wrong api_key" do
    before(:each) do
      ENV['SECRET_API_KEY'] = "SECRET_API_KEY"
      request.headers["Authorization"] = "WRONG_api_key"
      post :create, params: { user: user_attr }
    end

    it { expect(response.status).to eq 401 }
  end

  describe "DELETE /users/:id #destroy" do
    context "when is deleted" do
      before(:each) { signed_delete :destroy, params: { id: "not_used" } }

      it "cannot be found anymore" do
        expect { User.find(user.id) }.to raise_error(
                                                  ActiveRecord::RecordNotFound)
      end

      it { expect(response.status).to eq 204 }
    end

    context "when not correctly authorized" do
      before(:each) { delete :destroy, params: { id: "not_used" } }

      it { expect(response.status).to eq 401 }
    end
  end
end
