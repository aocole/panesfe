require 'rails_helper'

RSpec.describe Slideshow do
  describe "sorting" do
    let(:slideshow) { FactoryGirl.build :slideshow }

    it "should define a row order for new slides" do
      original_order = []
      %w{one two}.each do |num|
        original_order << slideshow.slides.build
      end

      expect(slideshow.save).to be_truthy, slideshow.errors.full_messages.inspect

      rank_first = slideshow.slides.rank(:row_order).first
      expect(rank_first.row_order).to be_a Integer
      expect(rank_first).to eq original_order.first
      expect(rank_first.row_order).to be < slideshow.slides.rank(:row_order).last.row_order

      rank_first.row_order_position = 1
      rank_first.save!

      slideshow.reload

      rank_first = slideshow.slides.rank(:row_order).first
      expect(rank_first.row_order).to be < slideshow.slides.rank(:row_order).last.row_order
      expect(rank_first).to eq original_order.last

    end
    

  end
end

