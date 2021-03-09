require 'spec_helper'
require_relative '../../../../apps/web/views/books/new'

class NewBookParams < Hanami::Action::Params
  params do
    required(:book).schema do
      required(:title).filled(:str?)
      required(:author).filled(:str?)
    end
  end
end

describe Web::Views::Books::New do
  let(:params)    { NewBookParams.new(book: {}) }
  let(:exposures) { Hash[params: params] }
  let(:template)  { Hanami::View::Template.new('apps/web/templates/books/new.html.erb') }
  let(:view)      { Web::Views::Books::New.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'displays list of errors when params contains errors' do
    params.valid? # trigger validations

    _(rendered).must_include('There was a problem with your submission')
    _(rendered).must_include('Title is missing')
    _(rendered).must_include('Author is missing')
  end
end

