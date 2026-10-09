# frozen_string_literal: true

RSpec.describe Bookshelf::Structs::Book do
  let(:book) do
    described_class.new(
      id: 1,
      title: "The Song of the Iron Sea",
      author: "C. Cole",
      created_at: Time.utc(2020, 1, 1),
      updated_at: Time.utc(2020, 1, 2)
    )
  end

  it "is a ROM struct value object" do
    expect(described_class).to be < Bookshelf::DB::Struct
  end

  it "exposes its attributes as accessors" do
    expect(book.id).to eq(1)
    expect(book.title).to eq("The Song of the Iron Sea")
    expect(book.author).to eq("C. Cole")
    expect(book.created_at).to eq(Time.utc(2020, 1, 1))
    expect(book.updated_at).to eq(Time.utc(2020, 1, 2))
  end

  it "can be built from a plain record hash" do
    from_hash = described_class.new(id: 2, title: "T", author: "A",
                                    created_at: Time.now, updated_at: Time.now)
    expect(from_hash.title).to eq("T")
  end

  it "exposes its attributes as a hash via #to_h" do
    expect(book.to_h).to match(
      id: 1, title: "The Song of the Iron Sea", author: "C. Cole",
      created_at: Time.utc(2020, 1, 1), updated_at: Time.utc(2020, 1, 2)
     )
  end

  it "compares by value and hashes by value" do
    other = described_class.new(
      id: 1, title: "The Song of the Iron Sea", author: "C. Cole",
      created_at: Time.utc(2020, 1, 1), updated_at: Time.utc(2020, 1, 2)
    )
    expect(book).to eq(other)
    expect(book.hash).to eq(other.hash)
  end

  it "serializes to JSON without printing a struct object" do
    expect(book.to_json).to include('"title"').and include("The Song of the Iron Sea")
  end
end
