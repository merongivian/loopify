require 'opal-browser'
require 'opal-music'

module Music
  class SequencesController < Volt::ModelController
    def controls

    end

    def play(notes, audio_context, tempo)
      @sequence = Music::Sequence.new(audio_context, tempo, notes)

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
  end
end
