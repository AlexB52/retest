require 'spec_helper'
require_relative '../../../../apps/web/controllers/books/new'

describe Web::Controllers::Books::New do
  let(:action) { Web::Controllers::Books::New.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    _(response[0]).must_equal 200
  end
end
