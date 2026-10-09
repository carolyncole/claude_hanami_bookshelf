# frozen_string_literal: true

RSpec.describe Bookshelf::Repos::BookRepo, type: :db do
  subject(:repo) { described_class.new }

   # Success/Failure come from the Dry::Monads::Result the repo includes.
  include Dry::Monads[:result]

  describe ".new" do
    it "infers its root from the class name (the :books relation)" do
      expect(repo.root.name.to_sym).to eq(:books)
    end
  end

  describe "#all" do
    it "returns every book struct" do
      repo.create(title: "Alpha", author: "A")
      repo.create(title: "Beta", author: "B")

      books = repo.all

      expect(books.map(&:title).sort).to eq(%w[Alpha Beta])
      expect(books.all?).to be(true)
    end

    it "returns an empty collection when there are no books" do
      expect(repo.all).to eq([])
    end
  end

  describe "#create" do
    it "inserts a row and returns Success(struct)" do
      result = repo.create(title: "The Song", author: "C. Cole")

      expect(result).to be_success
      expect(result.value!.title).to eq("The Song")
      expect(result.value!.author).to eq("C. Cole")
    end

    it "assigns created_at and updated_at at insert time" do
      before = Time.now

      result = repo.create(title: "T", author: "A")
      book = result.value!

      expect(book.created_at).to be >= before
      expect(book.updated_at).to be >= before
      expect(book.id).to be_a(Integer)
    end

    it "persists the row so a later #get finds it" do
      created = repo.create(title: "Found me", author: "W").value!

      found = repo.get(id: created.id)
      expect(found.value!.title).to eq("Found me")
    end

    it "returns the inserted struct as a Bookshelf::Structs::Book" do
      result = repo.create(title: "T", author: "A")
      expect(result.value!).to be_a(Bookshelf::Structs::Book)
    end
  end

  describe "#get" do
    it "returns Success(struct) for a known id" do
      created = repo.create(title: "Here", author: "Now").value!
      result = repo.get(id: created.id)

      expect(result).to be_success
      expect(result.value!.id).to eq(created.id)
    end

    it "returns Failure(BookNotFound) for an unknown id instead of raising" do
      result = repo.get(id: 9_999)

      expect(result).to be_failure
      expect(result.failure).to be_a(described_class::BookNotFound)
      expect(result.failure.id).to eq(9_999)
    end

    it "exposes the missing id on the failure" do
      failure = repo.get(id: 4_242).failure
      expect(failure.message).to eq("Book not found: 4242")
    end
  end

  describe "#update" do
    it "updates title and author and bumps updated_at" do
      created = repo.create(title: "Old", author: "Old").value!

      result = repo.update(id: created.id, title: "New", author: "Newer")

      expect(result).to be_success
      expect(result.value!.title).to eq("New")
      expect(result.value!.author).to eq("Newer")
    end

    it "returns Failure when the id does not exist" do
      result = repo.update(id: 1, title: "X", author: "Y")
      expect(result).to be_failure
      expect(result.failure).to be_a(described_class::BookNotFound)
    end
  end

  describe "#delete" do
    it "removes the row and returns Success(id)" do
      created = repo.create(title: "Bye", author: "Gone").value!

      result = repo.delete(id: created.id)

      expect(result).to be_success
      expect(result.value!).to eq(created.id)
      expect(repo.get(id: created.id)).to be_failure
    end
  end
end
