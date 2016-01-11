require 'spec_helper'
require 'music/lib/sequence_decorator'

describe SequenceDecorator do
  let!(:sequence_decorator) do
    sequence_record  = store._sequences.create(
      title: 'low',
      quantity: 4
    ).value.tap do |sequence|
      %w(Bb2 F3).each { |note| sequence._notes.create(value: note) }
      [true, false, true].each { |on_off| sequence._cells.create(value: on_off) }
    end

    SequenceDecorator.new(sequence_record)
  end

  describe '#complete_notes' do
    it 'returns simple formatted notes' do
      expect(sequence_decorator.complete_notes).to eq %w(Bb2 F3 - -)
    end

    it 'returns formated notes with duration' do
      expect(sequence_decorator.complete_notes true)
        .to eq ['Bb2 q', 'F3 q', '- q', '- q']
    end
  end

  describe '#cell_values' do
    it 'returns cell values as an array' do
      expect(sequence_decorator.cell_values).to match_array [true, false, true]
    end
  end
end
