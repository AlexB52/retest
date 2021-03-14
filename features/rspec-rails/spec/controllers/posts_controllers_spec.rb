require 'rails_helper'

RSpec.describe PostsController, type: :controller do

  describe 'GET #new' do
    subject { get :new }

    it 'is successful' do
      subject
      expect(response).to be_successful
    end
  end

  describe 'GET #index' do
    subject { get :index }

    it 'is successful' do
      subject
      expect(response).to be_successful
    end
  end
end