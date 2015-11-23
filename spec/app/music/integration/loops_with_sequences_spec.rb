require 'spec_helper'

describe 'loop with sequences', type: :feature do
  let!(:cool_loop) do
    store._loops.create(title: 'cool', tempo: 50, volume: 60).value
  end

  before do
    visit '/loops/cool'
  end

  describe 'loop data' do
    it 'shows the loop title' do
      expect(page).to have_content cool_loop._title
    end

    it 'shows the loop volume' do
      expect(page).to have_field 'volume', with: cool_loop._volume.to_s
    end

    it 'shows the loop tempo' do
      expect(page).to have_field 'tempo', with: cool_loop._tempo.to_s
    end
  end

  describe 'sequences data' do
    let!(:bass_sequence) do
      cool_loop._sequences.create(title: 'bass', volume: 20, effect: 'square').value
    end

    let!(:lead_sequence) do
      cool_loop._sequences.create(title: 'lead', volume: 40, effect: 'sine').value
    end

    it "shows current loop sequences" do
      expect(page).to have_content bass_sequence._title
      expect(page).to have_content lead_sequence._title
    end

    it 'shows the volume for each sequence' do
      expect(page).to have_field 'bass_volume', with: bass_sequence._volume.to_s
      expect(page).to have_field 'lead_volume', with: lead_sequence._volume.to_s
    end

    it 'shows effects for each sequence' do
      expect(page).to have_field 'bass_effect', with: bass_sequence._effect
      expect(page).to have_field 'lead_effect', with: lead_sequence._effect
    end
  end
end
