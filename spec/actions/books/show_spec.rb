# frozen_string_literal: true

# Action-level spec for `GET /books/:id` (plus the `set_book` before-action).
RSpec.describe Bookshelf::Actions::Books::Show, type: :db do
  subject(:repo) { Bookshelf::Repos::BookRepo.new }

  describe "GET /books/:id" do
    it "renders 200 with the book when it exists" do
      book = repo.create(title: "The Song", author: "C. Cole").value!

      response = request(path: "/books/#{book.id}")

      expect(response.status).to eq(200)
      expect(response.body).to include(book.title, book.author)
      expect(response.body).to include("Edit this book", "Destroy this book")
    end

    it "returns 404 with a plain body when the id does not exist" do
      response = request(path: "/books/9_999")

      expect(response.status).to eq(404)
      expect(response.body).to eq("Book not found")
    end
  end
end
