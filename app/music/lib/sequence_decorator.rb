require 'opal-music'
require 'music/lib/notes_format'

class SequenceDecorator
  def initialize(sequence_record)
    @sequence_record = sequence_record
  end

  def complete_notes(with_duration = false)
    notes_format = NotesFormat.new(
      @sequence_record._notes.map(&:_value),
      @sequence_record._quantity.to_i
    )

    with_duration ? notes_format.add_duration : notes_format.complete
  end

  def audio(audio_context, tempo)
    Music::Sequence.new(audio_context,
                        tempo,
                        complete_notes(true))
  end
end
