require 'rails_helper'
require 'support/pundit_matcher'
describe PresentationPolicy do
  subject { PresentationPolicy.new(actor, presentation) }

  let(:presentation) { FactoryGirl.build_stubbed(:presentation, :user => owner) }

  context "for a regular user" do
    let(:actor) {FactoryGirl.build_stubbed(:user, :role => User.roles[:user])}

    context "acting on their own presentation" do
      let(:owner) {actor}
      it {should permit(:show)}

      it "should only show presentations belonging to the user" do
        FactoryGirl.create_list(:presentation, 3, :user => owner)
        FactoryGirl.create_list(:presentation, 4, :user => FactoryGirl.build_stubbed(:user))
        expect(Pundit.policy_scope(actor, Presentation).count).to eq(3)
      end
    end

    context "acting on another's presentation" do
      let(:owner) {FactoryGirl.build_stubbed(:user)}
      it {should_not permit(:show)}
    end


  end

end
