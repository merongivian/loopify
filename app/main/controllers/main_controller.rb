# By default Volt generates this controller for your Main component
#
require 'date'

module Main
  class MainController < Volt::ModelController
    before_action :require_login, only: [:loops, :explore]

    def index
      # Add code for when the index view is loaded
    end

    def about
      # Add code for when the about view is loaded
    end

    def loops

    end

    def explore

    end

    private

    def add_loop
      if page._loop_title.blank?
        flash._errors << "Title can't be blank"
        `document.getElementById("loop-modal-close").click()`
        return
      end

      loopy = Volt.current_user._loops.create(
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
        Volt.current_user._news.create(value: "created loop #{page._loop_title}", date: Date.today.to_s)

        redirect_to "/#{user_name}/loops/#{page._loop_title}"
      end
    end

    def set_loop_defaults
      page._loop_sequences_size = 2
      page._loop_size = 5
    end

    def follow(friend)
      Volt.current_user._friends.create value: friend
      Volt.current_user._news.create(value: "followed #{friend._name}", date: Date.today.to_s)
    end

    def unfollow(friend)
      friends = current_user_friends.value.dup
      Volt.current_user._friends.reverse.each(&:destroy)

      friends.delete_if { |f| f._name == friend._name }
      friends.each do |saved_friend|
        Volt.current_user._friends.create(value: saved_friend)
      end
      Volt.current_user._news.create(value: "unfollowed #{friend._name}", date: Date.today.to_s)
    end

    def current_user_news
      current_user_friends.flat_map do |friend|
        friend._news.all.value.map do |n|
          { friend: friend._name, news: n._value, date: n._date }
        end
      end
    end

    def current_user_friends_names
      current_user_friends.map(&:_name)
    end

    def current_user_friends
      Volt.current_user._friends.map(&:_value)
    end

    # The main template contains a #template binding that shows another
    # template.  This is the path to that template.  It may change based
    # on the params._component, params._controller, and params._action values.
    def main_path
      "#{params._component || 'main'}/#{params._controller || 'main'}/#{params._action || 'index'}"
    end

    def user_name
      Volt.current_user.value.name
    end

    # Determine if the current nav component is the active one by looking
    # at the first part of the url against the href attribute.
    def active_tab?
      url.path.split('/')[1] == attrs.href.split('/')[1]
    end
  end
end
