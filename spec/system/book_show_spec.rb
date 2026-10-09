# frozen_string_literal: true

# Hanami port of the original `spec/system/book_show_spec.rb`.
#
# STATUS: `books#show` is not wired, so `/books/:id` returns a 404 -- red on the
# content assertions.
RSpec.describe "book/", type: :system do
  it "visits the book show page" do
    book = create_book(title: "book 1", author: "author 1")
    create_book(title: "book 2", author: "author 2")
    visit "/books/#{book.id}"

    expect(page).to have_content "Title: book 1"
    expect(page).not_to have_content "Title: book 2"
    expect(page).to have_content "Author: author 1"
    expect(page).not_to have_content "Author: author 2"
  end
end
