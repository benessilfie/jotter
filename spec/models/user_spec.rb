# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  auth_token      :string
#  email           :string
#  password_digest :string
#  role            :integer          default("member")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require "rails_helper"

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  describe "validations" do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:password_digest) }
    it { should allow_value(user.email).for(:email) }
    it { should_not allow_values("user", "user@", "user@hey", "user@hey.").for(:email) }
  end

  describe "password" do
    it { should have_secure_password }
  end

  describe "enums" do
    it { should define_enum_for(:role).with_values(admin: 0, member: 1) }
  end

  describe "associations" do
    it { should have_many(:notes).dependent(:destroy) }

    it "should delete associated notes when user is deleted" do
      user.save
      note = create(:note, user: user)
      expect { user.destroy }.to change { Note.count }.by(-1)
    end
  end

  describe "CRUD" do
    it "should create a new user" do
      expect { user.save }.to change { User.count }.by(1)
    end

    it "should create a new user with a role of admin" do
      user.role = "admin"
      expect(user.role).to eq("admin")
    end

    it "should not allow a new user to be created with an existing email" do
      user.save
      user2 = build(:user)
      expect(user2.save).to be false
    end

    it "should read an existing user" do
      user.save
      expect(User.last).to eq(user)
    end

    it "should update an existing user" do
      user.save
      user.update(email: "ess@hey.com")
      expect(User.last.email).to eq("ess@hey.com")
    end

    it "should delete an existing user" do
      user.save
      expect { user.destroy }.to change { User.count }.by(-1)
    end
  end
end
