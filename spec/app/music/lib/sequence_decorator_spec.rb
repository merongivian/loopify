require 'spec_helper'
require 'music/lib/sequence_decorator'

describe SequenceDecorator do
  describe '#complete_notes' do
    let!(:sequence_decorator) do
      sequence_record  = store._sequences.create(
        title: 'low',
        quantity: 4
      ).value.tap do |sequence|
        %w(Bb2 F3).each { |note| sequence._notes.create(value: note) }
      end

      SequenceDecorator.new(sequence_record)
    end

    it 'returns simple formatted notes' do
      expect(sequence_decorator.complete_notes).to eq %w(Bb2 F3 - -)
    end

    it 'returns formated notes with duration' do
      expect(sequence_decorator.complete_notes true)
        .to eq ['Bb2 q', 'F3 q', '- q', '- q']
    end
  end
end
