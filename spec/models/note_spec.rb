require 'spec_helper'

describe Note do
  it "has a valid factory" do
    expect(FactoryGirl.build(:note)).to be_valid
  end

  it "is invalid without a title" do
    expect(FactoryGirl.build(:note, title: nil)).to_not be_valid
  end

  it "validates presence of title" do
    note = Note.new
    expect(note.valid?).to be false
    expect(note.errors.keys).to include(:title)
  end

  it "creates a valid note" do
    note = FactoryGirl.build(:note)
    expect(note.save).to be true
  end
end
