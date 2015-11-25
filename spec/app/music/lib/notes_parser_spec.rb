require 'spec_helper'
require 'music/lib/notes_parser'

describe NotesFormat do
  let(:notes_format) { NotesFormat.new %w(D3 Bb2) }

  describe '#for_quantity' do
    it 'returns one note' do
      expect(notes_format.for_quantity 1).to eq %w(D3)
    end

    it 'returns two notes' do
      expect(notes_format.for_quantity 2).to eq %w(D3 Bb2)
    end

    it 'returns two notes plus two empty notes' do
      expect(notes_format.for_quantity 4).to eq %w(D3 Bb2 - -)
    end

    it 'returns two notes plus 6 empty notes' do
      expect(notes_format.for_quantity 8)
        .to eq %w(D3 Bb2 - - - - - -)
    end

    it 'raises an error for an invalid quantity' do
      expect { notes_format.for_quantity :any }
        .to raise_error 'quantity should be a valid duration'
    end
  end

  describe '#with_duration_for' do
    it 'uses with_duration to get the number the number of notes' do
      expect(notes_format).to receive(:for_quantity)
        .with(1)
        .and_call_original

      notes_format.with_duration_for 1
    end

    it 'returns all notes with the same duration' do
      expect(notes_format.with_duration_for 2).to eq ['D3 h', 'Bb2 h']
    end
  end
end
