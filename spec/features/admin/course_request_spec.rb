require 'rails_helper'

describe "courses", js: :true do
  let(:admin) { create(:user, admin: true) }

  before do
    sign_in_as(admin)
  end

  it 'allows an admin to create a course with levels' do
    visit '/courses/new'

    fill_in 'Name', with: 'Lisp'
    fill_in 'Title', with: 'Lisp for Llamas'
    fill_in 'Description', with: 'An introductory Lisp course for Llamas'

    click_on 'Add another level'
    within '.course-levels .fields', match: :first do
      fill_in 'Num', with: 1
      fill_in 'Color', with: 'blue'
      fill_in 'Title', with: 'Beginner'
      fill_in 'Level description', with: "* Desires adventure\n* Has hill climbing skills"
    end

    click_on 'Create Course'

    expect(page).to have_content('Admin Dashboard')

    created_course = Course.last
    expect(created_course.title).to eq('Lisp for Llamas')

    created_level = Level.last
    expect(created_level.title).to eq('Beginner')
    expect(created_level.level_description).to eq(['Desires adventure', 'Has hill climbing skills'])
  end
end