require 'spec_helper'

describe 'sequence with notes', type: :feature do
  let(:notes) do
    [
      { value: 'D3' }, { value: 'Bb2' }
    ]
  end

  let!(:sequence) do
    cool_loop = store._loops.create(
      title: 'cool',
      tempo: 50,
      volume: 60
    ).value

    cool_loop._sequences.create(
      title: 'bass',
      volume: 20,
      effect: 'square',
      quantity: 2
    ).value.tap do |sequence|
      notes.each { |note| sequence._notes.create(note) }
    end
  end

  before { visit '/loops/cool' }

  describe 'showing notes' do
    it 'shows the number of notes' do
      expect(page).to have_field 'quantity', with: '2'
    end

    it 'shows them with their values' do
      within('.notes .values') do
        expect(page).to have_selector('select', count: 2)
      end

      expect(page).to have_field 'note0', with: 'D3'
      expect(page).to have_field 'note1', with: 'Bb2'
    end
  end

  describe 'changing the number of notes' do
    it 'shows fields for adding new notes' do
      select('4', from: 'quantity')

      within('.notes .values') do
        expect(page).to have_selector('select', count: 4)
      end

      expect(page).to have_field 'note0', with: 'D3'
      expect(page).to have_field 'note1', with: 'Bb2'
      expect(page).to have_field 'note2', with: '-'
      expect(page).to have_field 'note3', with: '-'
    end
  end
end
