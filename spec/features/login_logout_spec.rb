require 'rails_helper'

describe "user login and logout" do

  let(:user) { FactoryGirl.create(:user) }

  it "allows a logged-in user to view the presentations index page" do
    log_in_as(user)
    visit(presentations_path)
    expect(current_path).to eq(presentations_path)
    expect(page).to have_content user.email
  end  

  it "logs out a logged-in user" do
    log_in_as(user)
    expect(current_path).to eq(logged_in_home_path)
    visit(logout_path)
    expect(current_path).to eq(login_path)
    expect(page).not_to have_content user.email
  end  

  it "prevents a non-logged-in user from viewing the presentations index page" do
    not_logged_in
    visit(presentations_path)
    expect(current_path).to eq(login_path)
    expect(page).not_to have_content user.email
  end  

  def log_in_as(user)
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[user.provider.intern] = OmniAuth::AuthHash.new({
      provider: user.provider.to_s,
      uid: user.uid,
    })
    visit "/auth/#{user.provider}"
  end

  def not_logged_in
    OmniAuth.config.test_mode = false
  end

end
