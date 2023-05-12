require "rails_helper"

RSpec.describe "NotesController", type: :request do
  let(:user) { create(:user) }
  let(:admin) { create(:admin) }

  describe "GET /notes" do
    context "when user is authenticated" do
      it "returns a list of notes owned by the user" do
        create_list(:note, 5, user: user)
        create(:note, user: admin)

        get notes_path, headers: { "Authorization" => "Bearer #{user.token}" }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["data"].size).to eq(5)
      end

      it "returns a list of all notes if user is an admin" do
        create_list(:note, 5, user: user)
        create_list(:note, 5, user: admin)

        get notes_path, headers: { "Authorization" => "Bearer #{admin.token}" }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["data"].size).to eq(10)
      end
    end
  end

  context "when user is not authenticated" do
    it "returns unauthorized status" do
      get notes_path

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "GET /notes/:id" do
    context "when note exists" do
      let(:note) { create(:note, user: user) }

      it "returns the note" do
        get notes_path(note.id), headers: { "Authorization" => "Bearer #{user.token}" }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["data"][0]["id"].to_i).to eq(note.id)
      end
    end

    context "when note does not exist" do
      it "returns 404 not found" do
        get "/notes/999", headers: { "Authorization" => "Bearer #{user.token}" }

        expect(response).to have_http_status(:not_found)
      end
    end

    context "when user is not authenticated" do
      it "returns unauthorized status" do
        get notes_path

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when user is not the owner of the note" do
      let(:note) { create(:note, user: admin) }

      it "returns unauthorized status" do
        get "/notes/#{note.id}", headers: { "Authorization" => "Bearer #{user.token}" }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "POST /notes" do
    context "when user is authenticated" do
      it "creates a new note" do
        note = build(:note, user: user)
        post notes_path, params: { title: note.title, content: note.content, published: note.published }, headers: { "Authorization" => "Bearer #{user.token}" }

        expect(response).to have_http_status(:created)
      end
    end

    context "when user is not authenticated" do
      it "returns unauthorized status" do
        post notes_path, params: { title: "Title", content: "Content", published: true }

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when note is invalid" do
      it "returns 400 bad request" do
        post notes_path, params: { title: nil, content: nil, published: nil }, headers: { "Authorization" => "Bearer #{user.token}" }

        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe "PUT /notes/:id" do
    context "when note exists" do
      it "updates the note" do
        note = create(:note, user: user)

        put "/notes/#{note.id}", params: { published: true }, headers: { "Authorization" => "Bearer #{user.token}" }
        expect(response).to have_http_status(:ok)
      end
    end

    context "when note does not exist" do
      it "returns 404 not found" do
        put "/notes/999", params: { published: true }, headers: { "Authorization" => "Bearer #{user.token}" }

        expect(response).to have_http_status(:not_found)
      end
    end

    context "when attempting to update a note that does not belong to the user" do
      it "returns unauthorized status" do
        note = create(:note, user: admin)

        put "/notes/#{note.id}", params: { published: true }, headers: { "Authorization" => "Bearer #{user.token}" }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE /notes/:id" do
    context "when note exists" do
      it "deletes the note" do
        note = create(:note, user: user)

        delete "/notes/#{note.id}", headers: { "Authorization" => "Bearer #{user.token}" }
        expect(response).to have_http_status(:no_content)
      end
    end

    context "when note does not exist" do
      it "returns 404 not found" do
        delete "/notes/999", headers: { "Authorization" => "Bearer #{user.token}" }

        expect(response).to have_http_status(:not_found)
      end
    end

    context "when attempting to delete a note that does not belong to the user" do
      it "returns unauthorized status" do
        note = create(:note, user: admin)

        delete "/notes/#{note.id}", headers: { "Authorization" => "Bearer #{user.token}" }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when user is an admin" do
      it "delete any note" do
        note = create(:note, user: user)

        delete "/notes/#{note.id}", headers: { "Authorization" => "Bearer #{admin.token}" }
        expect(response).to have_http_status(:no_content)
      end
    end
  end
end
