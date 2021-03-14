require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'title validations' do
    let(:invalid_post) { Post.new }

    it { expect(Post.new(title: 'title')).to be_valid }

    it 'is invalid when title is nil' do
      expect(invalid_post).to be_invalid
      expect(invalid_post.errors.full_messages_for(:title)).to eql [
        "Title can't be blank"
      ]
    end
  end
end
