require 'opal-browser'
require 'opal-music'

require 'music/lib/sequence_decorator'

module Music
  class SequencesController < Volt::ModelController
    attr_reader :audio_sequence

    def controls

    end

    def play(audio_context, tempo)
      @audio_sequence = sequence_decorator.audio_seq(audio_context, tempo.to_i)

      #NOTE: only works when defined after play
      #@audio_sequence.staccato  = 0.05
      #@audio_sequence.smoothing = 0.4
      #@audio_sequence.custom_wave_type([-0.8, 1, 0.8, 0.8, -0.8, -0.8, -1])

      @audio_sequence.loop_mode = _loop_mode
      @audio_sequence.play
    end

    def stop
      @audio_sequence.stop
    end

    def reload
      return if @audio_sequence.nil?
      @audio_sequence.oscillator = nil
      play
    end

    def set_volume
      @sequence.gain.gain = _volume.to_i / 100 / 2
    end

    def set_effect
      @audio_sequence.wave_type = _effect
    end

    def change_notes
      changed_notes = sequence_decorator.complete_notes

      _notes.reverse.each(&:destroy)

      changed_notes.each { |n| _notes.create(value: n) }

      reload_audio_sequence(@audio_sequence)
    end

    def reload_audio_sequence(local_audio_sequence)
      local_audio_sequence.notes = sequence_decorator.complete_notes(true)
    end

    def available_key_notes
      #@available_key_notes ||= Music::Note::OFFSETS.keys.product((2..7).to_a).map(&:join)
    end

    def stop_live_note
      p "stoped"
    end

    private

    def sequence_decorator
      SequenceDecorator.new(self)
    end
  end
end
