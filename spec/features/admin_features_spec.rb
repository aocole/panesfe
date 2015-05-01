require 'rails_helper'

describe "admin presentations" do
  context "as admin user" do

    let(:user) { FactoryGirl.create(:user, role: User.roles[:admin]) }
    let(:fake_panesd) { instance_double(Panesd) }

    before :each do
      log_in_as user
      @presentation = FactoryGirl.create(:slideshow, user: user)
    end

    it "should have working push button", :vcr do
      visit presentations_path

      page.find('tr', text: @presentation.name).click_link I18n.t('helpers.links.push')
      expect(current_path).to eq(presentations_path)
      expect(page).to have_content(I18n.t('controllers.presentations.presentation_pushed'))
    end

    it "should detect disconnected panesd server", :vcr do
      allow(fake_panesd).to receive(:push).and_raise(Errno::ECONNREFUSED)
      allow(Panesd).to receive(:new).
        with("http://localhost/presentations/#{@presentation.id}/display").
        and_return(fake_panesd)

      visit presentations_path
      page.find('tr', text: @presentation.name).click_link I18n.t('helpers.links.push')
      expect(current_path).to eq(presentations_path)
      expect(page).to have_content(I18n.t('controllers.presentations.panesd_offline'))
    end
  end

  context "as regular user" do

    let(:user) { FactoryGirl.create(:user, role: User.roles[:user]) }

    before :each do
      log_in_as user
      @presentation = FactoryGirl.create(:slideshow, user: user)
    end

    it "should not have push button", :vcr do
      visit presentations_path
      expect(page).not_to have_content(I18n.t('helpers.links.push'))
    end

  end
end
