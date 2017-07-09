require "rails_helper"

feature "User creates post" do
  scenario "successfully" do
    visits_the_root_path
    click_on "New Post"
    fill_in "Content", with: "Very good content. Good Job!"
    clicks_submit
    expect(page).to have_css '.posts li', text: "Very good content. Good Job!"
  end

  def clicks_submit
    click_on "Submit"
  end

  def visits_the_root_path
    visit root_path
  end
end
