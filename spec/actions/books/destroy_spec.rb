# frozen_string_literal: true

# Action-level spec for `DELETE /books/:id`. The repository `delete` is
# idempotent and always returns a `Success`, so the redirect happens for any id.
RSpec.describe Bookshelf::Actions::Books::Destroy, type: :db do
  subject(:repo) { Bookshelf::Repos::BookRepo.new }

  describe "DELETE /books/:id" do
    it "deletes the book and redirects (303) to the index with a notice" do
      book = repo.create(title: "The Song", author: "C. Cole").value!

      response = request(path: "/books/#{book.id}", method: :delete)

      expect(response.status).to eq(303)
      expect(response.headers["Location"])
          .to match(%r{^/books\?notice=Book\+was\+successfully\+destroyed\.})
      expect(repo.all).to be_empty
    end

          # `repo.delete` is idempotent: deleting an absent id still "succeeds",
     # so the action redirects just the same.
    it "redirects even when the id does not exist (idempotent delete)" do
      response = request(path: "/books/9_999", method: :delete)

      expect(response.status).to eq(303)
      expect(response.headers["Location"]).to include("/books")
    end
  end
end
