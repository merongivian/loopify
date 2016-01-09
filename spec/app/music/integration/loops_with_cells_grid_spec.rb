require 'spec_helper'

describe 'loop schedule grid', type: :feature do
  describe 'sequence cells' do
    it 'show on/off data for each cell' do
      cool_loop = store._loops.create(title: 'cool', tempo: 50, volume: 60).value

      low_sequence  = cool_loop._sequences.create(
        title: 'low',
        volume: 20,
        effect: 'square'
      ).value

      low_sequence._cells.create(value: false)
      low_sequence._cells.create(value: true)
      low_sequence._cells.create(value: false)

      visit '/loops/cool'

      expect(find_field 'cell0').to_not be_checked
      expect(find_field 'cell1').to be_checked
      expect(find_field 'cell2').to_not be_checked
    end
  end
end
