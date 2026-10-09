# frozen_string_literal: true

# Action-level spec for `PATCH /books/:id` (plus the `set_book` before-action).
RSpec.describe Bookshelf::Actions::Books::Update, type: :db do
  subject(:repo) { Bookshelf::Repos::BookRepo.new }

  describe "PATCH /books/:id" do
          # Spaces in the flash notice are form-encoded to `+` in the Location.
    it "updates the book and redirects (303) with a success notice" do
      book = repo.create(title: "The Song", author: "C. Cole").value!

      response = request(
         path: "/books/#{book.id}",
         method: :patch,
         params: {"book" => {"title" => "The Song 2", "author" => "C. Cole II"}}
          )

      expect(response.status).to eq(303)
      expect(response.headers["Location"])
          .to match(%r{^/books/#{book.id}\?notice=Book\+was\+successfully\+updated\.})
      expect(repo.get(id: book.id).value!.title).to eq("The Song 2")
      expect(repo.get(id: book.id).value!.author).to eq("C. Cole II")
    end

        # The update really mutated the row: the timestamp bumped.
    it "bumps updated_at when the row changes" do
      created = repo.create(title: "T", author: "A").value!
      updated_at_before = created.updated_at
      sleep 0.01

      request(path: "/books/#{created.id}", method: :patch,
               params: {"book" => {"title" => "T2", "author" => "A2"}}
               )

      expect(repo.get(id: created.id).value!.updated_at).to be > updated_at_before
    end

    # The `set_book` before-action equivalent: an update of a missing id answers
    # with a 404 rather than crashing or creating a new row.
    it "returns 404 when the id does not exist" do
      response = request(path: "/books/9_999", method: :patch,
                         params: {"book" => {"title" => "Nope", "author" => "X"}}
                         )

      expect(response.status).to eq(404)
      expect(response.body).to eq("Book not found")
      expect(repo.all).to be_empty
    end
  end
end
