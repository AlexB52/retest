require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:post_record) { Post.create(title: 'title') }

  describe 'GET #new' do
    it 'is successful' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'GET #index' do
    it 'is successful' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'is successful' do
      get :show, params: { id: post_record.id }
      expect(response).to be_successful
    end
  end

  describe 'GET #edit' do
    it 'is successful' do
      get :edit, params: { id: post_record.id }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    subject { post :create, params: { post: { title: 'title' } } }

    it 'creates a post' do
      expect { subject }.to change { Post.count }.by(1)

      expect(response).to redirect_to post_url(Post.last)
    end
  end

  describe 'PATCH #update' do
    it 'updates post' do
      patch :update, params: { id: post_record.id, post:  {title: post_record.title} }
      expect(response).to redirect_to post_url(Post.last)
    end
  end

  describe 'DELETE #destroy' do
    subject { delete :destroy, params: { id: post_record.id} }

    before { post_record }

    it 'deletes post' do
      expect { subject }.to change { Post.count }.by(-1)

      expect(response).to redirect_to posts_url
    end
  end
end
