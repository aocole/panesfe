require 'rails_helper'

describe "Display methods access control" do
  let(:user) { FactoryGirl.create(:user) }
  let(:theme_name) { Faker::Commerce.product_name }
  let(:user_presentation) do
   FactoryGirl.create(:presentation, 
      user: user, 
      theme: FactoryGirl.create(:theme, name: theme_name, content: "<html><body>#{theme_name}</body></html>")
    )
  end
      
  context 'with no presentations' do
    it 'should not display an error' do
      expect {visit(next_presentations_path)}.not_to raise_error 
      expect(page).not_to have_content 'wrong'
    end
  end

  context 'when videowall authenticated' do
    it "should be able to display a presentation" do
      visit(display_presentation_path(user_presentation))
      expect(page).to have_content theme_name
    end
  end

  context 'when not videowall authenticated' do
    it "should not allow completely unauthenticated user to display presentation" do
      skip "Need to revisit access control for 'display' methods"
      visit(display_presentation_path(user_presentation))
      expect(page).to have_content "You need to log in"
    end

    it "should not allow regular user to display presentation" do
      skip "Need to revisit access control for 'display' methods"
      log_in_as(user)
      visit(display_presentation_path(user_presentation))
      expect(page).to have_content I18n.t('controllers.auth.not_authorized')
    end
  end


end
