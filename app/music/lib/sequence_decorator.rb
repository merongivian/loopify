require 'opal-music'
require 'music/lib/notes_format'

class SequenceDecorator
  attr_reader :db_record

  def initialize(db_record)
    @db_record = db_record
  end

  def complete_notes(with_duration = false)
    notes_format = NotesFormat.new(
      @db_record._notes.map(&:_value),
      @db_record._quantity.to_i
    )

    with_duration ? notes_format.add_duration : notes_format.complete
  end

  def cell_values
    @db_record._cells.map(&:_value)
  end

  def audio_seq(audio_context, tempo)
    audio_sequence = Music::Sequence.new(audio_context,
                                         tempo,
                                         complete_notes(true))

    audio_sequence.volume    = @db_record._volume.to_i / 100 / 2
    audio_sequence.wave_type = @db_record._effect
    audio_sequence
  end
end
