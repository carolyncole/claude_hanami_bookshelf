# frozen_string_literal: true

# Action-level spec for `GET /books/:id/edit` (plus the `set_book` before-action).
RSpec.describe Bookshelf::Actions::Books::Edit, type: :db do
  subject(:repo) { Bookshelf::Repos::BookRepo.new }

  describe "GET /books/:id/edit" do
    it "renders 200 with the update form pre-filled when the book exists" do
      book = repo.create(title: "The Song", author: "C. Cole").value!

      response = request(path: "/books/#{book.id}/edit")

      expect(response.status).to eq(200)
      expect(response.body).to include("Editing book", "Update Book")
      expect(response.body).to include(book.title, book.author)
    end

      # A PATCH (not a POST) via the hidden _method, targeting the member route.
    it "submits the form as a PATCH against the member route" do
      book = repo.create(title: "The Song", author: "C. Cole").value!

      response = request(path: "/books/#{book.id}/edit")

      expect(response.body).to match(/name="_method" value="patch"/)
      expect(response.body).to match(%r{<form action="/books/#{book.id}" method="post">})
    end

    it "returns 404 when the id does not exist" do
      response = request(path: "/books/9_999/edit")

      expect(response.status).to eq(404)
      expect(response.body).to eq("Book not found")
    end
  end
end
