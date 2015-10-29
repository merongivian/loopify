require 'opal-browser'
require 'opal-music'

module Music
  class SequencesController < Volt::ModelController
    def controls

    end

    def play(notes)
      ac = Browser::Audio::Context.new
      tempo = 132

      @sequence = Music::Sequence.new(ac, tempo, notes)

      # set staccato and smoothing values for maximum coolness
      #@sequence.staccato  = 0.05
      #@sequence.smoothing = 0.4

      set_volume
      set_effect
      @sequence.play
    end

    def set_volume
      @sequence.gain.gain = _volume.to_i / 100 / 2
    end

    def set_effect
      @sequence.wave_type = _effect
    end
  end
end
