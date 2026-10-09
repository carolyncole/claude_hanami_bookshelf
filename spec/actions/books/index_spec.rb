# frozen_string_literal: true

# Action-level spec for `GET /books`. Exercises routing + action + view for
# the index, browser-less. See {ActionResponse} for the `request` helper.
RSpec.describe Bookshelf::Actions::Books::Index, type: :db do
       # Builds a book and asks the question "is it in the response?".
  subject(:repo) { Bookshelf::Repos::BookRepo.new }

  describe "GET /books" do
    it "renders 200 and lists every book" do
      book = repo.create(title: "The Song", author: "C. Cole").value!

      response = request(path: "/books")

      expect(response.status).to eq(200)
      expect(response.body).to include("Welcome to the Bookshelf")
      expect(response.body).to include(book.title, book.author)
    end

    it "renders the notice banner when a ?notice= param is present" do
      response = request(path: "/books", params: {notice: "Book was successfully created."})

      expect(response.status).to eq(200)
      expect(response.body).to include("Book was successfully created.")
    end
  end
end
