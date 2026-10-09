# frozen_string_literal: true

# Hanami port of the original `spec/system/book_create_spec.rb`.
#
# The Rails spec drove a real browser against the `books#new`/`#create` action
# pair and asserted on the resulting flash + persisted record. Here the data is
# seeded with {BookFactory#last_book} (the model layer) and the HTTP round-trip
# is driven by Capybara's `rack_test` against `Hanami.app`.
#
# STATUS: the `books` HTTP layer is not wired, so `/books/new` returns a 404 and
# the form can never render -- this example goes red.
RSpec.describe "books/new", type: :system do
  it "visits new book page and creates a book" do
    visit "/books/new"

    fill_in "Title", with: "awesome book"
    fill_in "Author", with: "Jane Doe"

    click_on "Create Book"
    expect(page).to have_content("Book was successfully created")
    book = last_book
    expect(book.title).to eq("awesome book")
    expect(book.author).to eq("Jane Doe")
  end
end
