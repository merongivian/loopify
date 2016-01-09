class NotesFormat
  DURATION = { 1 => 'w', 2 => 'h', 4 => 'q', 8 => 'e' }

  def initialize(notes, quantity)
    DURATION.key?(quantity) or
      fail 'quantity should be a valid duration'

    @notes    = notes
    @quantity = quantity
  end

  def add_duration
    complete.map do |note|
      "#{note} #{DURATION[@quantity]}"
    end
  end

  def complete
    if @quantity > @notes.length
      @notes + ['-'] * (@quantity - @notes.length)
    else
      @notes.take @quantity
    end
  end
end
