require 'rails_helper'

RSpec.describe Presentation do
  describe "initialization" do
    let(:presentation) { Presentation.new }

    it 'should create a slideshow presentation' do
      expect(presentation.save).to be_falsy
      expect(presentation.errors[:user]).to be_truthy
      expect(presentation.errors[:name]).to be_truthy
      expect(presentation.errors[:theme]).to be_truthy
      expect(presentation.errors[:folder_zip]).to be_truthy

      presentation.name = 'whatever'
      presentation.theme = FactoryGirl.build_stubbed(:theme)
      presentation.user = FactoryGirl.build_stubbed(:user)

      expect(presentation.save).to be_truthy, presentation.errors.full_messages.join
      expect(presentation.slideshow?).to be_truthy
      expect(presentation.folder?).to be_falsy
    end

    it 'should create a folder presentation' do
      presentation.name = Faker::Commerce.product_name
      presentation.user = FactoryGirl.build_stubbed(:user)
      File.open(Rails.root.join('seed/folder_zips/demo01.zip')) do |f|
        presentation.folder_zip = f
      end

      expect(presentation.save).to be_truthy, presentation.errors.full_messages.join
      expect(presentation.folder?).to be_truthy
      expect(presentation.slideshow?).to be_falsy
    end

    it "should not allow a presentation to be both folder and slideshow" do
      pres = FactoryGirl.build(:presentation)
      expect(pres.theme).to be_truthy
      File.open(Rails.root.join('seed/folder_zips/demo01.zip')) do |f|
        pres.folder_zip = f
      end
      expect(pres.folder?).to be_truthy
      expect(pres.slideshow?).to be_truthy

      expect(pres.save).to be_falsy
      expect(pres.errors[:theme]).to be_truthy
      expect(pres.errors[:folder_zip]).to be_truthy
      expect(pres.errors.full_messages.join).to include I18n.t('activerecord.errors.models.presentation.attributes.base.folder_xor_slideshow')
    end
  end

end
