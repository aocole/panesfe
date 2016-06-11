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

      expect(slideshow.save).to be_truthy, slideshow.errors.full_messages.join(', ')
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

      expect(foldershow.save).to be_truthy, foldershow.errors.full_messages.join(', ')
      expect(foldershow.foldershow?).to be_truthy
      expect(foldershow.slideshow?).to be_falsy
      expect(foldershow.find_index).to eq 'index.html'
    end

    it "should reject a malformed foldershow" do
      user = FactoryGirl.create :user
      show = FactoryGirl.build :foldershow, user: user
      File.open(Rails.root.join('spec/fixtures/no_index_foldershow.zip')) do |f|
        show.folder_zip = f
      end

      expect(show.save).to be_falsy
      expect(show.errors.keys).to eq [:folder_zip]
      expect(show.errors.full_messages.join(', ')).to include I18n.t('activerecord.errors.models.foldershow.attributes.folder_zip.no_index_found')
    end

    it "should accept a foldershow with nested index.html" do
      user = FactoryGirl.create :user
      show = FactoryGirl.build :foldershow, user: user
      File.open(Rails.root.join('spec/fixtures/emojitron.zip')) do |f|
        show.folder_zip = f
      end

      expect(show.save).to be_truthy
      expect(show.find_index).to eq 'emojitron/index.html'
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
      expect(pres.errors.full_messages.join(', ')).to include I18n.t('activerecord.errors.models.presentation.attributes.base.foldershow_xor_slideshow')
    end

    it "should be able to mark as broken" do
      user = FactoryGirl.create :user
      show = FactoryGirl.build :foldershow, user: user
      File.open(Rails.root.join('spec/fixtures/emojitron.zip')) do |f|
        show.folder_zip = f
      end
      expect(show.save).to be_truthy
      
      # should be able to use string
      expect{show.mark_broken!('no_index_found')}.not_to raise_error
      expect(show.broken_message_keys).to eq %W{no_index_found}
      
      # should not be able to use symbol
      expect{show.mark_broken!(:no_index_found)}.to raise_error(/not a valid broken message/)
    end

    it "should not have duplicate broken messages" do
      show = FactoryGirl.build :slideshow
      
      show.mark_broken!('no_index_found')
      show.mark_broken!('no_index_found')
      expect(show.broken_message_keys).to eq ['no_index_found']
    end

    it "should clear broken messages when the presentation is updated" do
      show = FactoryGirl.build :slideshow
      show.mark_broken!('no_index_found')
      expect(show.broken_message_keys).to eq ['no_index_found']

      # Should not change when also updating broken_message_keys
      show.name = "Maybe changing the name will fix it?"
      show.broken_message_keys = ['presentation_timeout']
      expect(show.save).to be_truthy
      expect(show.broken_message_keys).to eq ['presentation_timeout']

      show.name = "Maybe changing the name again will fix it?"
      expect(show.save).to be_truthy
      expect(show.broken_message_keys).to be_blank
    end

    it "should clear broken messages when a slideshow's slides are changed" do
      show = FactoryGirl.build :slideshow
      show.slides = [FactoryGirl.build(:slide, slideshow: show), FactoryGirl.build(:slide, slideshow: show)]
      show.mark_broken! 'presentation_timeout'
  
      slide = Slide.find(show.slides.last.id)
      expect(slide.destroy).to be_truthy
      show.reload
      expect(show.broken_message_keys).to be_blank
      

    end

    it "should have translations for all broken messages" do
      Presentation::BROKEN_MESSAGE_KEYS.each do |translation_key|
        expect{I18n.t!(Presentation.broken_message_to_i18n_key(translation_key), raise: true)}.not_to raise_error, "Should have translation for #{translation_key}"
      end
    end
  end

end
