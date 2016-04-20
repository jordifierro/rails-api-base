require 'spec_helper'

RSpec.describe NoteSerializer do
  describe 'Note json serialization' do
    let(:note) { build :note }
    let(:json) { NoteSerializer.new(note).serializable_hash }

    it 'renders json correctly' do
      expect(json[:id]).to eq note.id
      expect(json[:title]).to eq note.title
      expect(json[:content]).to eq note.content
      expect(json.key?(:user_id)).to be false
      expect(json.key?(:created_at)).to be false
      expect(json.key?(:updated_at)).to be false
    end
  end
end
