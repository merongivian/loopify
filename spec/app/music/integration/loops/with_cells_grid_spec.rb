require 'spec_helper'

describe 'loop schedule grid', type: :feature do
  let!(:cool_loop) do
    store._loops.create(title: 'cool', tempo: 50, size: 16,volume: 60).value
  end

  let(:cell_values) { [false, true] * 8 }

  let!(:low_sequence) do
    cool_loop._sequences.create(
      title: 'low',
      volume: 20,
      effect: 'square'
    ).value.tap do |sequence|
      cell_values.each { |state|
        sequence._cells.create(value: state)
      }
    end
  end

  before { visit '/loops/cool' }

  describe 'grid data' do
    it 'show on/off data for each cell' do
      within('#grid') {
        cell_values.each_with_index do |state, index|
          expect(find_field("cell#{index}").checked?).to eq state
        end
      }
    end

    it 'shows the limit size for the grid' do
      within('#grid') { expect(page).to have_field 'size', with: 16 }
    end
  end

  describe 'changing the grid size' do
    it 'shortens the grid size' do
      select('4', from: 'size')

      cell_values.first(4).each_with_index do |state, index|
        expect(find_field("cell#{index}").checked?).to eq state
      end

      (4..15).to_a.each do |index|
        within('#grid') { expect(page).to_not have_field "cell#{index}" }
      end
    end

    it 'doesnt erase previous data when toggling resize' do
      select('4', from: 'size')
      select('16', from: 'size')

      cell_values.each_with_index do |state, index|
        expect(find_field("cell#{index}").checked?).to eq state
      end
    end
  end
end
