require 'rails_helper'

describe "presentation broken marking" do
  let(:user) { FactoryGirl.create(:user) }
  let(:broken_slideshow) { 
    FactoryGirl.create(:slideshow, 
      user: user, 
      broken_message_keys: %W{no_index_found}
    )
  }

  it "should display broken status to the user" do
    log_in_as user
    expect(broken_slideshow.broken_messages?).to be_truthy
    visit_expect presentations_path
    expect(find('table')).to have_content broken_slideshow.name
    expect(page).to have_css("tr.danger", :count => 1)
    expect(page).to have_content I18n.t(Presentation.broken_message_to_i18n_key('no_index_found'))
  end
end

