require 'rails_helper'
require 'support/pundit_matcher'
describe UserPolicy do
  subject { UserPolicy.new(actor, target_user) }

  context "for a regular user" do
    let(:actor) {FactoryGirl.create(:user, :role => User.roles[:user])}

    context "acting on themself" do
      let(:target_user) { actor }
      it {should_not permit(:new)}
      it {should_not permit(:create)}
      it {should_not permit(:destroy)}
      it {should_not permit(:edit)}
      it {should_not permit(:show)}
      it {should permit(:update)}
      it {should permit(:settings)}

      it "should only show the current user" do
        FactoryGirl.create_list(:user, 5)
        expect(Pundit.policy_scope(actor, User).to_a).to eq [actor]
      end

      it "should set permitted attributes" do
        expect(subject.permitted_attributes).to eq [:family_name, :given_name, :primary_presentation_id]
      end
    end

    context "acting on another user" do
      let(:target_user) {FactoryGirl.build_stubbed(:user)}
      it {should_not permit(:new)}
      it {should_not permit(:create)}
      it {should_not permit(:destroy)}
      it {should_not permit(:edit)}
      it {should_not permit(:show)}
      it {should_not permit(:update)}
      it {should_not permit(:settings)}

      it "should set permitted attributes" do
        expect(subject.permitted_attributes).to eq []
      end
    end

  end

  context "for an admin user" do
    let(:actor) {FactoryGirl.create(:user, :role => User.roles[:admin])}

    context "acting on themself" do
      let(:target_user) {actor}
      it {should permit(:new)}
      it {should permit(:create)}
      it {should_not permit(:show)}
      it {should_not permit(:destroy)}
      it {should_not permit(:edit)}
      it {should permit(:update)}

      it "should show all users" do
        FactoryGirl.create_list(:user, 5)
        expect(Pundit.policy_scope(actor, User).count).to eq(6) # self + 5
      end

      it "should set permitted attributes" do
        expect(subject.permitted_attributes).to eq [:family_name, :given_name, :primary_presentation_id, :custom_disk_quota_mb, :card_number]
      end

    end

    context "acting on another user" do
      let(:target_user) {FactoryGirl.build_stubbed(:user)}
      it {should permit(:new)}
      it {should permit(:create)}
      it {should permit(:show)}
      it {should permit(:destroy)}
      it {should permit(:edit)}
      it {should permit(:update)}

      it "should set permitted attributes" do
        expect(subject.permitted_attributes).to eq [:family_name, :given_name, :primary_presentation_id, :custom_disk_quota_mb, :card_number, :role]
      end

    end


  end

end
