require 'rails_helper'

RSpec.describe ReflectionsController, type: :controller do

  let(:reflection_title) { SecureRandom.urlsafe_base64(10) }
  let(:user) { FactoryGirl.create(:user) }
  let(:user2) { FactoryGirl.create(:user) }
  let(:reflection) { FactoryGirl.create(:reflection, :user => user) }
  let(:reflection2) { FactoryGirl.create(:reflection, :user => user2) }
  let(:invalid_reflection) { FactoryGirl.create(:invalid_reflection) }
  let(:current_user) { login_with user }
  let(:current_user2) { login_with user2 }
  let(:invalid_user) { login_with nil }
  let(:valid_attributes) { {title: reflection_title, user_id: user.id} }
  let(:invalid_attributes) { {title: nil} }
  let(:new_attributes) { FactoryGirl.attributes_for(:reflection, title: "new title", body: "new body") }

  shared_examples_for 'logged in access to reflections' do
    describe "GET #index" do
      it "assigns all reflections as @reflections" do
        get :index, { user_id: user.to_param }
        expect(assigns(:reflections)).to eq([reflection])
      end

      it "renders the index template" do
        get :index, { user_id: user.to_param }
        expect(response).to render_template(:index)
      end
    end

    describe "GET #show" do
      it "assigns the requested reflection as @reflection" do
        get :show, { :id => reflection.to_param, user_id: user.to_param }
        expect(assigns(:reflection)).to eq(reflection)
      end

    end

    describe "GET #new" do
      it "assigns a new reflection as @reflection" do
        get :new, { user_id: user.to_param }
        expect(assigns(:reflection)).to be_a_new(Reflection)
      end

      it "renders the new template" do
        get :new, { user_id: user.to_param }
        expect(response).to render_template(:new)
      end
    end

    describe "GET #edit" do
      it "assigns the requested reflection as @reflection" do
        get :edit, { :id => reflection.to_param, user_id: user.to_param }
        expect(assigns(:reflection)).to eq(reflection)
      end

      it "renders the edit template" do
        get :edit, { :id => reflection.to_param, user_id: user.to_param }
        expect(response).to render_template(:edit)
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new Reflection" do
          expect {
            post :create, { :reflection => valid_attributes, user_id: user.to_param }
          }.to change(Reflection, :count).by(1)
        end

        it "assigns a newly created reflection as @reflection" do
          post :create, { :reflection => valid_attributes, user_id: user.to_param }
          expect(assigns(:reflection)).to be_a(Reflection)
          expect(assigns(:reflection)).to be_persisted
        end

        it "redirects to the created reflection" do
          post :create, { :reflection => valid_attributes, user_id: user.to_param }
          expect(response).to redirect_to(reflection_path(reflection))
        end

      end

      context "with invalid params" do
        it "assigns a newly created but unsaved reflection as @reflection" do
          post :create, { :reflection => invalid_attributes, user_id: user.to_param }
          expect(assigns(:reflection)).to be_a_new(Reflection)
        end

        it "re-renders the 'new' template" do
          post :create, { :reflection => invalid_attributes, user_id: user.to_param }
          expect(response).to render_template("new")
        end
      end
    end

    describe "PUT #update" do
      context "with valid params" do

        it "updates the requested reflection" do
          put :update, { user_id: user.to_param, :id => reflection.to_param, :reflection => new_attributes }
          reflection.reload
          expect(reflection.title).to eq("new title")
        end

        it "assigns the requested reflection as @reflection" do
          put :update, { user_id: user.to_param, :id => reflection.to_param, :reflection => new_attributes }
          expect(assigns(:reflection)).to eq(reflection)
        end

        it "redirects to the reflection" do
          put :update, { user_id: user.to_param, :id => reflection.to_param, :reflection => new_attributes }
          expect(response).to redirect_to(reflection_path(reflection))
        end
      end

      context "with invalid params" do
        it "assigns the reflection as @reflection" do
          put :update, { user_id: user.to_param, :id => reflection.to_param, :reflection => invalid_attributes }
          expect(assigns(:reflection)).to eq(reflection)
        end

        it "re-renders the 'edit' template" do
          put :update, { user_id: user.to_param, :id => reflection.to_param, :reflection => invalid_attributes }
          expect(response).to render_template("edit")
        end
      end
    end

    describe "DELETE #destroy" do
      it "destroys the requested reflection" do
        expect {
          delete :destroy, { :id => reflection.to_param, user_id: user.to_param }
        }.to change(Reflection, :count).by(-1)
      end

      it "redirects to the reflections index" do
        delete :destroy, { :id => reflection.to_param, user_id: user.to_param }
        expect(response).to redirect_to(reflections_path)
      end
    end
  end #end of user logged in/shared example

  shared_examples_for 'restricted access when not logged in' do
    describe "GET #index" do
      before(:example) do
        get :index, { user_id: user.to_param }
      end
      it { is_expected.to redirect_to new_user_session_path }
    end

    describe "GET #show" do
      before(:example) do
        get :show, { :id => reflection.to_param, user_id: user.to_param }
      end
        it { is_expected.to redirect_to new_user_session_path }
    end

    describe "GET #new" do
      before(:example) do
        get :new, { user_id: user.to_param }
      end
     it { is_expected.to redirect_to new_user_session_path }
    end

    describe "GET #edit" do
      before(:example) do
        get :edit, { user_id: user.to_param, :id => reflection.to_param}
      end
     it { is_expected.to redirect_to new_user_session_path }
    end

    describe "POST #create" do
      context "with valid params" do
        before(:example) do
         post :create, { :reflection => valid_attributes, user_id: user.to_param }
        end
        it { is_expected.to redirect_to new_user_session_path }
      end

      context "with invalid params" do
        before(:example) do
          post :create, { :reflection => invalid_attributes, user_id: user.to_param }
        end
        it { is_expected.to redirect_to new_user_session_path }
      end
    end

    describe "PUT #update" do
      context "with valid params" do

        before(:example) do
          put :update, { user_id: user.to_param, :id => reflection.to_param, :reflection => new_attributes }
        end

       it { is_expected.to redirect_to new_user_session_path }
      end

      context "with invalid params" do
        before(:example) do
          put :update, { user_id: user.to_param, :id => reflection.to_param, :reflection => FactoryGirl.attributes_for(:invalid_reflection)}
        end
        it { is_expected.to redirect_to new_user_session_path }
      end
    end

    describe "DELETE #destroy" do

      before(:example) do
        delete :destroy, { :id => reflection.to_param, user_id: user.to_param }
      end
     it { is_expected.to redirect_to new_user_session_path }
    end

  end #end of user not logged in/shared example

  shared_examples_for 'users can only access their own reflections' do
    describe "GET #index" do
      it "assigns all reflections as @reflections" do
        get :index, { user_id: user2.to_param }
        expect(assigns(:reflections)).to eq([reflection])
        expect(assigns(:reflections)).not_to include(reflection2)
      end
    end

    describe "GET #show" do
      before(:example) do
        get :show, { :id => reflection2.to_param, user_id: user2.to_param }
      end
        it { is_expected.to redirect_to reflection_path(reflection) }
    end

    describe "GET #edit" do
      before(:example) do
        get :edit, { :id => reflection2.to_param, user_id: user2.to_param }
      end
     it { is_expected.to redirect_to reflection_path(reflection) }
    end

    describe "PUT #update" do
      context "with valid params" do

        before(:example) do
          put :update, { user_id: user2.to_param, :id => reflection2.to_param, :reflection => new_attributes }
        end

       it { is_expected.to redirect_to reflection_path(reflection) }
      end

      context "with invalid params" do
        before(:example) do
          put :update, { user_id: user2.to_param, :id => reflection2.to_param, :reflection => FactoryGirl.attributes_for(:invalid_reflection) }
        end
        it { is_expected.to redirect_to reflection_path(reflection) }
      end
    end

    describe "DELETE #destroy" do

      before(:example) do
        delete :destroy, { user_id: user2.to_param, :id => reflection2.to_param }
      end
     it { is_expected.to redirect_to reflections_path }
    end

  end #end of user can't access another user's reflections


  describe "user access" do
    before :each do
      current_user
      reflection
    end

    it_behaves_like 'logged in access to reflections'
  end

  describe "user not logged in" do
    before(:each) do
      invalid_user
      reflection
    end

    it_behaves_like 'restricted access when not logged in'
  end

  describe "user can't access others' reflections" do
    before(:each) do
      current_user
      reflection
      reflection2
    end

    it_behaves_like 'users can only access their own reflections'
  end

end #final ender