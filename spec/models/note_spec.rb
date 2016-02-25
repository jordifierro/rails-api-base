require 'spec_helper'

describe Note do
  let(:note) { build :note }

  describe 'responds to attrs' do
    it { expect(note).to respond_to(:title) }
    it { expect(note).to respond_to(:content) }
    it { expect(note).to respond_to(:user) }
  end

  it 'has a valid factory' do
    expect(note).to be_valid
  end

  it 'creates a valid note' do
    expect(note.save).to be true
  end

  it 'is invalid without a title' do
    expect(build(:note, title: nil)).to_not be_valid
  end

  it 'validates presence of title' do
    note = Note.new
    note.user = create :user
    expect(note.valid?).to be false
    expect(note.errors.keys).to include(:title)
  end

  it 'is invalid without a user' do
    expect(build(:note, user: nil)).to_not be_valid
  end

  it 'validates presence of user' do
    note = Note.new
    note.title = 'title'
    expect(note.valid?).to be false
    expect(note.errors.keys).to include(:user)
  end
end
