require 'spec_helper'

describe 'User loops', type: :feature do
  let(:credentials) do
    { username: 'juan', password: 'password', email: 'juan@site.com' }
  end

  let!(:juan) do
    store._users.create(credentials).value
  end

  before do
    log_in(credentials[:email], credentials[:password])
    visit '/juan/loops'
  end

  it 'can create a loop' do
    click_button 'New Loop'

    within('.modal-dialog') do
      fill_in('Title', with: 'Great')
      select('4', from: 'Sequences')
      select('20', from: 'Size')

      click_button('Create Loop')
    end

    expect(page).to have_content 'Great'

    within('#loop-header') do
      expect(page.all('#sequence-wrapper').length).to eq 4
    end
  end

  it 'shows a list with created loops from a user' do
    awesome_loop = juan._loops.create(title: 'awesome', size: 14).value
      .tap do |current_loop|
        current_loop._sequences.create(title: 'sequence 1')
        current_loop._sequences.create(title: 'sequence 2')
      end

    cool_loop = juan._loops.create(title: 'cool', size: 20).value
      .tap do |current_loop|
        current_loop._sequences.create(title: 'sequence 1')
        current_loop._sequences.create(title: 'sequence 2')
        current_loop._sequences.create(title: 'sequence 3')
      end

    within('#loop-index.table') do
      first_row = page.all('tr')[0]
      last_row = page.all('tr')[1]

      #| name | sequences | size

      expect(first_row.all('td')[0]).to eq 'awesome'
      expect(first_row.all('td')[1]).to eq 2
      expect(first_row.all('td')[2]).to eq 14

      expect(last_row.all('td')[0]).to eq 'cool'
      expect(last_row.all('td')[1]).to eq 3
      expect(last_row.all('td')[2]).to eq 20
    end
  end

end
