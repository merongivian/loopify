require 'opal-music'

require 'music/lib/sequence_decorator'

module Music
  class SequencesController < Volt::ModelController
    attr_reader :audio_sequence

    def controls

    end

    def play(audio_context, tempo)
      @audio_sequence = sequence_decorator.audio(audio_context, tempo.to_i)

      #NOTE: only works when defined after play
      #@audio_sequence.staccato  = 0.05
      #@audio_sequence.smoothing = 0.4
      #@audio_sequence.custom_wave_type([-0.8, 1, 0.8, 0.8, -0.8, -0.8, -1])

      set_volume
      set_effect

      @audio_sequence.loop_mode = true
      @audio_sequence.play
    end

    def stop
      @audio_sequence.stop
    end

    def set_volume
      @audio_sequence.volume = _volume.to_i / 100 / 2
    end

    def set_effect
      @audio_sequence.wave_type = _effect
    end

    def change_notes
      changed_notes = audio_sequence_decorator.complete_notes

      _notes.reverse.each(&:destroy)

      changed_notes.each { |n| _notes.create(value: n) }
      reload_sequence(@audio_sequence)
    end

    def reload_audio_sequence(local_audio_sequence)
      local_audio_sequence.notes = sequence_decorator.complete_notes(true)
    end

    private

    def sequence_decorator
      SequenceDecorator.new(self)
    end
  end
end
