require 'spec_helper'

describe Book do
  it 'can be initialised with attributes' do
    book = Book.new(title: 'Refactoring')
    _(book.title).must_equal 'Refactoring'
  end
end
