require 'rails_helper'

describe "videowall" do
  def basic_auth(name, password)
    if page.driver.respond_to?(:basic_auth)
      page.driver.basic_auth(name, password)
    elsif page.driver.respond_to?(:basic_authorize)
      page.driver.basic_authorize(name, password)
    elsif page.driver.respond_to?(:browser) && page.driver.browser.respond_to?(:basic_authorize)
      page.driver.browser.basic_authorize(name, password)
    else
      raise "I don't know how to log in!"
    end
  end
 
  let(:user) { FactoryGirl.create(:user) }
  let(:theme_name) { Faker::Commerce.product_name }
  let(:user_presentation) do
   FactoryGirl.create(:presentation, 
      user: user, 
      theme: FactoryGirl.create(:theme, name: theme_name, content: "<html><body>#{theme_name}</body></html>")
    )
  end
      
  context 'when HTTP basic authenticated' do
    it "should be able to display a presentation" do
      basic_auth(Rails.application.secrets.videowall_user, Rails.application.secrets.videowall_password)
      visit(display_presentation_path(user_presentation))
      expect(page).to have_content theme_name
    end
  end

  context 'when not http basic authenticated authenticated' do
    it "should not allow completely unauthenticated user to display presentation" do
      visit(display_presentation_path(user_presentation))
      expect(page).to have_content "You need to log in"
    end

    it "should not allow regular user to display presentation" do
      log_in_as(user)
      visit(display_presentation_path(user_presentation))
      expect(page).to have_content I18n.t('controllers.auth.not_authorized')
    end
  end


end
