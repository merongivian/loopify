class NotesFormat
  DURATION = { 1 => 'w', 2 => 'h', 4 => 'q', 8 => 'e' }

  def initialize(notes)
    @notes = notes
  end

  def with_duration_for(quantity)
    for_quantity(quantity).map do |note|
      "#{note} #{DURATION[quantity]}"
    end
  end

  def for_quantity(quantity)
    unless DURATION.keys.include? quantity
      fail 'quantity should be a valid duration'
    end

    if quantity > @notes.length
      @notes + ['-'] * (quantity - @notes.length)
    else
      @notes[0..(quantity - 1)]
    end
  end
end
