require 'rails_helper'

describe GrowingPanes do
  it "should initialize" do
    expect{GrowingPanes.config['user']['upload_root_dir']}.not_to raise_error
  end

  it "should expand upload path" do
    expect(GrowingPanes.config['user']['upload_root_dir']).to match(Rails.root.to_s)
  end

end
