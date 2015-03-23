require 'rails_helper'

RSpec.describe Theme do
  describe "initialization" do
    let(:theme) { Theme.new }

    it 'creates a new theme with a minimum set of attributes' do
      expect(theme.save).to be_falsy
      expect(theme.errors[:user]).to be_truthy
      expect(theme.errors[:name]).to be_truthy

      expect(theme.content).to_not be_nil

      theme.name = 'whatever'
      theme.user = FactoryGirl.build_stubbed(:user)

      expect(theme.save).to be_truthy, theme.errors.full_messages.join
    end
  end

end
