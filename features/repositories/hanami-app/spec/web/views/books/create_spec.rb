require 'spec_helper'
require_relative '../../../../apps/web/views/books/create'

describe Web::Views::Books::Create do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Hanami::View::Template.new('apps/web/templates/books/create.html.erb') }
  let(:view)      { Web::Views::Books::Create.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #foo' do
    skip 'This is an auto-generated test. Edit it and add your own tests.'

    # Example
    _(view.foo).must_equal exposures.fetch(:foo)
  end
end
