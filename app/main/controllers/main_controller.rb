# By default Volt generates this controller for your Main component
module Main
  class MainController < Volt::ModelController
    before_action :require_login, only: :loops

    def index
      # Add code for when the index view is loaded
    end

    def about
      # Add code for when the about view is loaded
    end

    def loops

    end

    private

    def add_loop
      if page._loop_title.blank?
        flash._errors << "Title can't be blank"
        `document.getElementById("loop-modal-close").click()`
        return
      end

      loopy = current_user._loops.create(
        title: page._loop_title,
        tempo: 160,
        size: page._loop_size.to_i,
        volume: 60
      ).then do |added_loop|
        page._loop_sequences_size.to_i.times do |index|
          added_loop._sequences.create(
            title: "Sequence #{index}",
            volume: 20,
            effect: 'square',
            quantity: 4
          ).then do |added_sequence|
            4.times { added_sequence._notes.create(value: '-') }
            32.times { added_sequence._cells.create(value: false) }
          end
        end

        redirect_to "/#{params._username}/loops/#{page._loop_title}"
      end
    end

    def set_loop_defaults
      page._loop_sequences_size = 2
      page._loop_size = 5
    end

    def current_user
      store.users.where(username: params._username).first
    end

    # The main template contains a #template binding that shows another
    # template.  This is the path to that template.  It may change based
    # on the params._component, params._controller, and params._action values.
    def main_path
      "#{params._component || 'main'}/#{params._controller || 'main'}/#{params._action || 'index'}"
    end

    # Determine if the current nav component is the active one by looking
    # at the first part of the url against the href attribute.
    def active_tab?
      url.path.split('/')[1] == attrs.href.split('/')[1]
    end
  end
end
