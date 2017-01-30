require 'opal-browser'
require 'opal-music'
require 'music/lib/sequence_decorator'

module Music
  class LoopsController < Volt::ModelController
    before_action :require_login, only: :editor
    after_action :disable_keyboard_notes, only: :editor

    def editor
    end

    def grid
      init_key_down_handler
    end

    def play_grid
      audio_constants = [audio_context, current_loop._tempo.value.to_i]
      current_time = @audio_context.current_time

      sequence_decorators.each do |decorator|
        Music::PlaySchedule.new(
          decorator.audio_seq(*audio_constants),
          decorator.cell_values.take(current_size)
        ).start(current_time)
      end
    end

    private

    def disable_keyboard_notes
      %x{
        $('a').click(function() {
          document.onkeypress = null;
        });
      }
    end

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
      @audio_context ||= Browser::Audio::Context.new
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

    def init_key_down_handler
      %x{
        document.onkeypress = function(evt) {
          evt = evt || window.event;
          var charCode = evt.keyCode || evt.which;
          #{ note_played = key_player.play `String.fromCharCode(charCode)`
          flash.__notes << note_played
          };
        };
      }
    end

    def key_player
      @key_player ||= Music::KeyboardSynth.new(audio_context)
    end
  end
end
