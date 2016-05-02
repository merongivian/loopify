require 'opal-music'
require 'music/lib/sequence_decorator'

module Music
  class LoopsController < Volt::ModelController
    before_action :require_login, only: :editor

    def editor

    end

    def grid

    end

    def play_grid
      audio_constants = [audio_context, current_loop._tempo.value.to_i]

      sequence_decorators.each do |decorator|
        Music::PlaySchedule.new(
          decorator.audio(*audio_constants),
          decorator.cell_values.take(current_size)
        ).start
      end
    end

    private

    def current_cells(sequence)
      sequence._cells.take(current_size)
    end

    def current_size
      current_loop._size.value.to_i
    end

    def sequence_decorators
      current_loop._sequences.value.map do |sequence|
        SequenceDecorator.new(sequence)
      end
    end

    def audio_context
      @audio_context ||= Music.audio_context
    end

    def current_loop
      loop_user._loops.where(title: params._title).first
    end

    def loop_user
      store.users.where(name: params._username).first
    end

    def current_loop_sorted_sequences
      current_loop._sequences.sort_by{ |sequence| sequence._title }
    end
  end
end
