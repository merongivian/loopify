require 'spec_helper'
require 'music/lib/notes_format'

describe NotesFormat do
  describe '#initialize' do
    it 'raise an error for invalid quantities' do
      expect { NotesFormat.new %w(D3 Bb2), 10 }
        .to raise_error 'quantity should be a valid duration'
    end
  end

  describe '#complete' do
    subject { NotesFormat.new(%w(D3 Bb2), quantity).complete }

    context 'for available notes' do
      let(:quantity) { 1 }

      it { is_expected.to eq %w(D3) }
    end

    context 'for non available notes' do
      let(:quantity) { 8 }

      it { is_expected.to eq %w(D3 Bb2 - - - - - -) }
    end
  end

  describe '#add_duration' do
    let(:notes_format) { NotesFormat.new(%w(D3 Bb2), 2) }

    it 'uses complete_notes to get notes with their values' do
      expect(notes_format).to receive(:complete)
        .and_call_original

      notes_format.add_duration
    end

    it 'returns all notes with the same duration' do
      expect(notes_format.add_duration).to eq ['D3 h', 'Bb2 h']
    end
  end
end
