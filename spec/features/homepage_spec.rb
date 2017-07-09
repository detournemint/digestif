require 'rails_helper'

feature 'Loads The Homepage' do
  scenario 'renders title' do
    visits_the_root_path
    expect(page).to have_css 'h1', text: 'Digestif'
  end

  pending 'sees signup button' do
    visits_the_root_path
    expect(page).to have_button 'Signup'
  end

  def visits_the_root_path
    visit root_path
  end

end
