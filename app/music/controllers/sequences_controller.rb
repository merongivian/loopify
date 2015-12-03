require 'opal-browser'
require 'opal-music'

require 'music/lib/notes_format'

module Music
  class SequencesController < Volt::ModelController
    def controls

    end

    def play(audio_context, tempo)
      @sequence = Music::Sequence.new(audio_context,
                                      tempo.to_i,
                                      notes_format.with_duration)

      #@sequence.staccato  = 0.05
      #@sequence.smoothing = 0.4
      #@sequence.custom_wave_type([-0.8, 1, 0.8, 0.8, -0.8, -0.8, -1])

      set_volume
      set_effect

      @sequence.play
    end

    def stop
      @sequence.stop
    end

    def set_volume
      @sequence.gain.gain = _volume.to_i / 100 / 2
    end

    def set_effect
      @sequence.wave_type = _effect
    end

    def change_notes
      changed_notes = notes_format.complete_notes

      _notes.reverse.each(&:destroy)
      changed_notes.each { |n| _notes.create(value: n) }
    end

    private

    def notes_format
      NotesFormat.new(_notes.map(&:_value), _quantity.to_i)
    end
  end
end
