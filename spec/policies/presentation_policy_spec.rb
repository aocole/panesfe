require 'rails_helper'
require 'support/pundit_matcher'
describe PresentationPolicy do
  subject { PresentationPolicy.new(actor, presentation) }

  let(:presentation) { FactoryGirl.build_stubbed(:slideshow, :user => owner) }

  context "for a regular user" do
    let(:actor) {FactoryGirl.build_stubbed(:user, :role => User.roles[:user])}

    context "acting on their own presentation" do
      let(:owner) {actor}
      it {should permit(:new)}
      it {should permit(:create)}
      it {should permit(:show)}
      it {should permit(:destroy)}
      it {should permit(:edit)}
      it {should permit(:update)}

      it "should only show presentations belonging to the user" do
        FactoryGirl.create_list(:slideshow, 3, :user => owner)
        FactoryGirl.create_list(:slideshow, 4, :user => FactoryGirl.build_stubbed(:user))
        expect(Pundit.policy_scope(actor, Presentation).count).to eq(3)
      end
    end

    context "acting on another's presentation" do
      let(:owner) {FactoryGirl.build_stubbed(:user)}
      it {should_not permit(:show)}
      it {should_not permit(:destroy)}
      it {should_not permit(:edit)}
      it {should_not permit(:update)}
    end


  end

  context "for an admin user" do
    let(:actor) {FactoryGirl.build_stubbed(:user, :role => User.roles[:admin])}

    context "acting on their own presentation" do
      let(:owner) {actor}
      it {should permit(:new)}
      it {should permit(:create)}
      it {should permit(:show)}
      it {should permit(:destroy)}
      it {should permit(:edit)}
      it {should permit(:update)}

      it "should show all presentations" do
        FactoryGirl.create_list(:slideshow, 3, :user => owner)
        FactoryGirl.create_list(:slideshow, 4, :user => FactoryGirl.build_stubbed(:user))
        expect(Pundit.policy_scope(actor, Presentation).count).to eq(7)
      end
    end

    context "acting on another's presentation" do
      let(:owner) {FactoryGirl.build_stubbed(:user)}
      it {should permit(:new)}
      it {should permit(:create)}
      it {should permit(:show)}
      it {should permit(:destroy)}
      it {should permit(:edit)}
      it {should permit(:update)}
    end


  end

end
