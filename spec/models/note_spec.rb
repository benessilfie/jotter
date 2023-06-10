# == Schema Information
#
# Table name: notes
#
#  id         :integer          not null, primary key
#  content    :text
#  published  :boolean
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_notes_on_user_id  (user_id)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
require "rails_helper"

RSpec.describe Note, type: :model do
  let(:user) { create(:user2) }
  let(:admin) { create(:admin2) }
  let(:note) { build(:note, user: user) }
  let(:other_user_note) { build(:note) }

  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:content) }
    it { should allow_value(true, false).for(:published) }
  end

  describe "associations" do
    it { should belong_to(:user) }
  end

  describe "CRUD" do
    context "when user is not an admin" do
        it "should create a new note" do
          expect { note.save }.to change { Note.count }.by(1)
        end

        it "should read their own notes" do
          note.save
          expect(user.notes).to include(note)
        end

        it "should not read notes of other users" do
          expect { user.notes.find(other_user_note.id) }.to raise_error(ActiveRecord::RecordNotFound)
        end

        it "should not update notes of other users" do
          expect { user.notes.find(other_user_note.id).update(title: "Updated title") }.to raise_error(ActiveRecord::RecordNotFound)
        end

        it "should delete their own notes" do
          note.save
          expect { user.notes.find(note.id).destroy }.to change { Note.count }.by(-1)
        end

        it "should not delete notes of other users" do
          expect { user.notes.find(other_user_note.id).destroy }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

    context "when user is an admin" do
      let(:note2) { build(:note, user: admin) }

      it "should create a new note" do
        expect { note2.save }.to change { Note.count }.by(1)
      end

      it "should read other users' notes" do
        other_user_note.save
        expect(other_user_note.user).not_to eq(admin)
      end

      it "should update other users' notes" do
        other_user_note.save
        other_user_note.update(title: "Updated title")
        expect(Note.last.title).to eq("Updated title")
      end

      it "should delete notes of other users" do
        other_user_note.save
        expect { other_user_note.destroy }.to change { Note.count }.by(-1)
      end
    end
  end
end

