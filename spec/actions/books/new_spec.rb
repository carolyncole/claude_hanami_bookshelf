# frozen_string_literal: true

RSpec.describe Bookshelf::Actions::Books::New do
  let(:params) { {} }

  it "renders a blank form that posts to /books" do
    response = subject.call(params)

    expect(response).to be_successful
    expect(response.body.join).to include('action="/books"', 'value="Create Book"')
  end
end
