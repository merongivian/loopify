require 'opal-music'

module Music
  class LoopsController < Volt::ModelController
    def editor

    end

    private

    def audio_context
      @audio_context ||= Music.audio_context
    end

    def current_loop
      store._loops.where(title: params._title).first
    end
  end
end
