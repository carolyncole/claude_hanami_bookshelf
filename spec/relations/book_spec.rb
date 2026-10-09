# frozen_string_literal: true

RSpec.describe Bookshelf::Relations::Book, type: :db do
  subject(:relation) { described_class }

  it "is a ROM/Sequel SQL relation" do
    expect(relation).to be < Bookshelf::DB::Relation
    expect(relation).to be < ROM::Relation[:sql]
  end

  it "is registered in the ROM container as the :books relation" do
    rom = Hanami.app["db.rom"]
    expect(rom.relations.key?(:books)).to be(true)
    expect(rom.relations[:books].name.to_sym).to eq(:books)
  end

  it "reads through the books table" do
    rom = Hanami.app["db.rom"]
    rom.relations[:books].insert(
      title: "Relation read", author: "A",
      created_at: Time.now, updated_at: Time.now
    )

    rows = rom.relations[:books].to_a
    expect(rows.map { |r| r[:title] }).to include("Relation read")
  end
end
