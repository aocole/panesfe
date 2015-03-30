require 'rails_helper'

RSpec.describe Presentation do
  describe "initialization" do
    let(:presentation) { Presentation.new }
    let(:fake_panesd) { instance_double(Panesd) }

    it 'creates a new presentation with a minimum set of attributes' do
      expect(presentation.save).to be_falsy
      expect(presentation.errors[:user]).to be_truthy
      expect(presentation.errors[:name]).to be_truthy
      expect(presentation.errors[:theme]).to be_truthy

      presentation.name = 'whatever'
      presentation.theme = FactoryGirl.build_stubbed(:theme)
      presentation.user = FactoryGirl.build_stubbed(:user)

      expect(presentation.save).to be_truthy, presentation.errors.full_messages.join
    end
  end

end
