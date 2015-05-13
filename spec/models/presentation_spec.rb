require 'rails_helper'

RSpec.describe Presentation do
  describe "initialization" do
    let(:slideshow) { Slideshow.new }
    let(:foldershow) { Foldershow.new }

    it 'should create a slideshow' do
      expect(slideshow.save).to be_falsy
      expect(slideshow.errors[:user]).to be_truthy
      expect(slideshow.errors[:name]).to be_truthy
      expect(slideshow.errors[:theme]).to be_truthy

      slideshow.name = 'whatever'
      slideshow.theme = FactoryGirl.build_stubbed(:theme)
      slideshow.user = FactoryGirl.build_stubbed(:user)

      expect(slideshow.save).to be_truthy, slideshow.errors.full_messages.join
      expect(slideshow.slideshow?).to be_truthy
      expect(slideshow.foldershow?).to be_falsy
    end

    it 'should create a foldershow' do
      expect(foldershow.save).to be_falsy
      expect(foldershow.errors[:user]).to be_truthy
      expect(foldershow.errors[:name]).to be_truthy
      expect(foldershow.errors[:folder_zip]).to be_truthy

      foldershow.name = Faker::Commerce.product_name
      foldershow.user = FactoryGirl.build_stubbed(:user)
      expect(foldershow.save).to be_falsy
      expect(foldershow.errors.keys).to eq [:folder_zip]
      
      File.open(Rails.root.join('seed/folder_zips/hello_world.zip')) do |f|
        foldershow.folder_zip = f
      end

      expect(foldershow.save).to be_truthy, foldershow.errors.full_messages.join
      expect(foldershow.foldershow?).to be_truthy
      expect(foldershow.slideshow?).to be_falsy
    end

    it "should require being either folder or slideshow" do
      pres = Presentation.new(user: FactoryGirl.build(:user), name: Faker::Commerce.product_name)
      expect(pres).not_to respond_to(:theme)
      File.open(Rails.root.join('seed/folder_zips/hello_world.zip')) do |f|
        pres.folder_zip = f
      end
      expect(pres.foldershow?).to be_falsy
      expect(pres.slideshow?).to be_falsy

      expect(pres.save).to be_falsy
      expect(pres.errors[:theme]).to be_truthy
      expect(pres.errors[:folder_zip]).to be_truthy
      expect(pres.errors.full_messages.join).to include I18n.t('activerecord.errors.models.presentation.attributes.base.foldershow_xor_slideshow')
    end
  end

end
