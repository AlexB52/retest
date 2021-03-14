require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'title validation' do
    let(:post) { Post.new }

    it 'is invalid with no title' do
      post.valid?
      expect(post.errors.full_messages_for(:title)).to eql [
        'Title can\'t be blank'
      ]
    end
  end
end
