# frozen_string_literal: true

# Hanami port of the original `spec/system/book_delete_spec.rb`.
#
# `Book.create`/`Book.count` become {BookFactory#create_book}/{BookFactory#book_count};
# the `delete` round-trip drives the `books#destroy` action via Capybara.
#
# STATUS: `books#show`/`#destroy` are not wired, so no content renders -- red.
RSpec.describe "books/new", type: :system do
  it "visits the book show page and destroys the book" do
    book = create_book(title: "book 1", author: "author 1")
    visit "/books/#{book.id}"

    expect(page).to have_content "Title: book 1"
    expect(page).to have_content "Author: author 1"

    expect { click_on "Destroy this book" }.to change { book_count }.by(-1)
    expect(page).to have_content("Book was successfully destroyed")
    expect(page).to have_content "Welcome to the Bookshelf"
  end
end
