require 'spec_helper'

describe Note do
  let(:note) { build :note }

  describe "responds to attrs" do
    it { expect(note).to respond_to(:title) }
    it { expect(note).to respond_to(:content) }
  end

  it "has a valid factory" do
    expect(note).to be_valid
  end

  it "is invalid without a title" do
    expect(build(:note, title: nil)).to_not be_valid
  end

  it "validates presence of title" do
    note = Note.new
    expect(note.valid?).to be false
    expect(note.errors.keys).to include(:title)
  end

  it "creates a valid note" do
    expect(note.save).to be true
  end
end
