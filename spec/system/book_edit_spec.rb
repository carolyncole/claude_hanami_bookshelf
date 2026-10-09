# frozen_string_literal: true

# Hanami port of the original `spec/system/book_edit_spec.rb`.
#
# `book.reload` becomes {BookFactory#get_book} (ROM structs are immutable, so a
# "reload" is a re-read by id).
#
# STATUS: `books#edit`/`#update` are not wired, so no form renders -- red.
RSpec.describe "book/", type: :system do
  it "visits the book show page and edits the book" do
    book = create_book(title: "book 1", author: "author 1")
    create_book(title: "book 2", author: "author 2")
    visit "/books/#{book.id}"

    expect(page).to have_content "Title: book 1"
    expect(page).not_to have_content "Title: book 2"
    expect(page).to have_content "Author: author 1"
    expect(page).not_to have_content "Author: author 2"
    click_on "Edit this book"

    expect(find("#book_title").value).to eq("book 1")
    expect(find("#book_author").value).to eq("author 1")
    fill_in "book_title", with: "book 1 update"

    click_on "Update Book"
    book = get_book(id: book.id)
    expect(book.title).to eq("book 1 update")
  end
end
