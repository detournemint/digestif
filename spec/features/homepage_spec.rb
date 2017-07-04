require 'rails_helper'

feature 'Loads The Homepage' do
  scenario 'renders title' do
    visit '/'
    expect(page).to have_css 'h1', text: 'Digestif'
  end
end
