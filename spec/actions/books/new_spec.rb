# frozen_string_literal: true

# Action-level spec for `GET /books/new` (Rails `@book = Book.new`).
RSpec.describe Bookshelf::Actions::Books::New, type: :db do
  describe "GET /books/new" do
       # A fresh book means an empty form: the fields exist, carry no value,
     # and post to the collection route.
    it "renders 200 with an empty create form" do
      response = request(path: "/books/new")

      expect(response.status).to eq(200)
      expect(response.body).to include("New book", "Create Book")
      expect(response.body).to include(%(id="book_author"), %(id="book_title"))
      expect(response.body).to include(%(value=""))
    end

       # A fresh form posts to the collection (no _method override, no id).
    it "posts the form to the books collection" do
      response = request(path: "/books/new")

      expect(response.body).to match(/<form action="\/books" method="post">/)
      expect(response.body).to match(/name="_method" value=""/)
    end
  end
end
