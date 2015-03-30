require 'rails_helper'

describe Panesd do
  it "can push", :vcr do
    display_presentation_url = 'http://foo.com'
    panesd = Panesd.new(display_presentation_url)
    expect(panesd.push).to eq(true)
  end
end
