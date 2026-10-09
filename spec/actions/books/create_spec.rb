# frozen_string_literal: true

# Action-level spec for `POST /books`. Exercises the full happy path
# (create + redirect + flash); the `Failure` branch is unreachable because the
# repository `create` always succeeds, so only the success path is covered.
RSpec.describe Bookshelf::Actions::Books::Create, type: :db do
  subject(:repo) { Bookshelf::Repos::BookRepo.new }

  describe "POST /books" do
          # `URI.encode_www_form_component` form-encodes spaces to `+`, not
     # `%20`, so the Location carries `Book+was+successfully+created.`.
    it "creates the book and redirects (302) to it with a success notice" do
      response = request(
         path: "/books",
         method: :post,
         params: {"book" => {"title" => "The Song", "author" => "C. Cole"}}
          )

      expect(response.status).to eq(302)
      expect(response.headers["Location"])
          .to match(%r{^/books/\d+\?notice=Book\+was\+successfully\+created\.})
    end

          # The row is really written, not merely the redirect fabricated.
    it "persists the title and author to the database" do
      request(path: "/books", method: :post,
                params: {"book" => {"title" => "The Song", "author" => "C. Cole"}}
                )

      books = repo.all
      expect(books.size).to eq(1)
      expect(books.first.title).to eq("The Song")
      expect(books.first.author).to eq("C. Cole")
    end

             # String-typed form keys are tolerated as well as symbol keys.
    it "tolerates string-typed form keys" do
      response = request(
         path: "/books",
         method: :post,
         params: {"book" => {"title" => "T", "author" => "A"}}
          )

      expect(response.status).to eq(302)
      expect(repo.all.last.title).to eq("T")
    end
  end
end
