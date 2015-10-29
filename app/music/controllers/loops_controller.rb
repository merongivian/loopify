module Music
  class LoopsController < Volt::ModelController
    def editor

    end

    private

    def current_loop
      store._loops.where(title: params._title).first
    end
  end
end
