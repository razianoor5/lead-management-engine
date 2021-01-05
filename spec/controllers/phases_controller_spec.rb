puts "rspec pid: #{Process.pid}"
require 'rails_helper'

RSpec.describe PhasesController, type: :controller do
  before do
    user.save
    sign_in user
  end

  describe 'GET #index' do
    let(:user) { create(:user) }
    let(:lead) { create(:lead, user: user) }
    let(:phase) { create(:phase, lead: lead) }

    it 'shows index page of leads and return success' do
      params = { user_id: user.id, lead_id: lead.id }
      get :index, params: params
      expect(response.status).to eq(200)
    end

    it 'shows index page of leads and return success' do
      params = { user_id: user.id, lead_id: lead.id }
      get :index, params: params
      expect(response.content_type).to eq 'text/html'
    end
  end

  describe 'GET #show' do
    let(:user) { create(:user) }
    let!(:manager) { create(:user, role: 'technical_manager') }
    let(:lead) { create(:lead, user: user) }
    let(:phase) { create(:phase, assignee: manager.email) }

    it 'shows a particular phase associated to a lead and return success' do
      params = { user_id: user.id, lead_id: lead.id, id: phase.id }
      get :show, params: params
      expect(response.status).to eq(200)
    end
  end

  describe 'GET #new' do
    let(:user) { create(:user) }
    let(:lead) { create(:lead, :with_phases, user: user) }

    it 'can only be shown when business developer is signed in' do
      params = { user_id: user.id, lead_id: lead.id }
      get :new, params: params
      expect(response.status).to eq(200)
    end
  end

  describe 'GET #edit' do
    context 'with authorized user' do
      let(:user) { create(:user) }
      let(:lead) { create(:lead, :with_phases, user: user) }

      it 'show success when user is business_developer' do
        params = { user_id: user.id, lead_id: lead.id, id: lead.phases.first.id }
        get :edit, params: params
        expect(response.status).to eq(200)
      end
    end

    context 'with unauthorized user' do
      let(:user) { create(:user, :engineer) }
      let(:user_business_developer) { create(:user) }
      let(:lead) { create(:lead, :with_phases, user: user_business_developer) }

      it 'redirects when user is not business_developer' do
        params = { user_id: user.id, lead_id: lead.id, id: lead.phases.first.id }
        get :edit, params: params
        expect(response.status).to eq(302)
      end
    end
  end

  describe 'POST #create' do
    context 'with authorized user' do
      let(:user) { create(:user) }
      let(:user_manager) { create(:user, :technical_manager) }
      let(:lead) { create(:lead, :with_phases, user: user) }

      it 'phase will be created when user is  business_developer' do
        params = { lead_id: lead.id, phase: { phase_type: 'Test', assignee: user_manager.email,
                  start_date: Faker::Date.between(from: '2020-12-11', to: '2020-12-22'),
                  due_date: Faker::Date.between(from: '2020-12-23', to: '2020-12-30'), lead_id: lead.id } }
        post :create, params: params
        expect(flash[:notice]).to eq 'Phase was successfully created.'
      end

      it 'will not create phase as assignee is not technical_manager' do
        params = { lead_id: lead.id, phase: { phase_type: 'Test', assignee: user.email,
                  start_date: Faker::Date.between(from: '2020-12-11', to: '2020-12-22'),
                  due_date: Faker::Date.between(from: '2020-12-23', to: '2020-12-30'), lead_id: lead.id } }
        post :create, params: params
        expect(flash[:notice]).to eq 'Wrong user email entered! Enter technical managers email'
      end
    end

    context 'with unauthorized user' do
      let(:user_bd) { create(:user) }
      let(:user) { create(:user, :technical_manager) }
      let(:user_manager) { create(:user, :technical_manager) }
      let(:lead) { create(:lead, :with_phases, user: user_bd) }

      it 'will not allow to create phase ' do
        params = { lead_id: lead.id, phase: { phase_type: 'Test', assignee: user_manager.email,
                  start_date: Faker::Date.between(from: '2020-12-11', to: '2020-12-22'),
                  due_date: Faker::Date.between(from: '2020-12-23', to: '2020-12-30'), lead_id: lead.id } }
        post :create, params: params
        expect(flash[:alert]).to eq 'You are not authorized to perform this action.'
      end
    end
  end

  describe 'PUT/PATCH #update' do
    context 'with authorized user' do
      let(:user) { create(:user) }
      let(:lead) { create(:lead, :with_phases, user: user) }

      it 'show success when user is business_developer' do
        params = { user_id: user.id, lead_id: lead.id, id: lead.phases.first.id, phase: { phase_type: 'Interview'} }
        put :update, params: params
        expect(response.status).to eq(302)
        expect(flash[:notice]).to eq 'Phase was successfully updated.'
      end

      it 'show success when user is business_developer' do
        params = { user_id: user.id, lead_id: lead.id, id: lead.phases.first.id, phase: { phase_type: '' } }
        put :update, params: params
        expect(response.status).to eq(200)
        expect(subject.request.flash[:notice]).to eql 'Phase was not updated.'
      end
    end
  end

  describe 'POST #destroy' do
    context 'with authorized user' do
      let(:user) { create(:user) }
      let(:lead) { create(:lead, :with_phases, user: user) }

      it 'show success when user is business_developer' do
        params = { user_id: user.id, lead_id: lead.id, id: lead.phases.first.id }
        delete :destroy, params: params
        expect(flash[:notice]).to eq 'Phase was successfully destroyed.'
      end

      it 'will redirect to phases index' do
        params = { lead_id: lead.id, id: lead.phases.first.id }
        delete :destroy, params: params
        expect(response).to redirect_to lead_phases_url
      end
    end

    context 'with unauthorized user' do
      let(:user) { create(:user, :technical_manager) }
      let(:user_bd) { create(:user) }
      let(:lead) { create(:lead, :with_phases, user: user_bd) }

      it 'will not allow to delete phase when user is not business_developer' do
        params = { lead_id: lead.id, id: lead.phases.first.id }
        delete :destroy, params: params
        expect(flash[:alert]).to eq 'You are not authorized to perform this action.'
      end

      it 'will redirect to phases index' do
        params = { lead_id: lead.id, id: lead.phases.first.id }
        delete :destroy, params: params
        expect(response).to redirect_to lead_phases_url
      end
    end
  end

  describe 'POST #engineer' do
    context 'when signed in as technical manager' do
      let(:user) { create(:user, email: lead.phases.first.assignee) }
      let(:user_bd) { create(:user) }
      let(:lead) { create(:lead, :with_phases, user: user_bd) }
      let(:user_eng) { create(:user, :engineer) }

      it 'will assign engineer if engineer is not already assigned' do
        params = { user_id: user.id, lead_id: lead.id, id: lead.phases.first.id, engineer: { user_id: user_eng.id } }
        post :engineer, params: params
        expect(flash[:notice]).to eq 'Engineer was successfully added.'
      end
    end

    context 'when engineer already assigned' do
      let(:user) { create(:user, email: lead.phases.first.assignee) }
      let(:user_bd) { create(:user) }
      let(:lead) { create(:lead, :with_phases, user: user_bd) }
      let(:user_eng) { create(:user, :engineer) }

      it 'will not assign engineer' do
        params = { user_id: user.id, lead_id: lead.id, id: lead.phases.first.id, engineer: { user_id: lead.phases.first.users.first.id } }
        post :engineer, params: params
        expect(flash[:alert]).to eq 'already assigned in the phase'
      end
    end
  end

  describe 'GET#complete' do
    context 'when phase is not complete' do
      let(:user) { create(:user) }
      let(:lead) { create(:lead, :with_phases, user: user) }

      it 'will mark the phase complete' do
        params = { user_id: user.id, lead_id: lead.id, id: lead.phases.first.id, phase: lead.phases.first }
        get :complete, params: params
        expect(flash[:alert]).to eq 'Phase marked as complete successfully'
      end
    end
    # context 'when phase is not complete' do
    #   let(:user) { create(:user) }
    #   let(:lead) { create(:lead, :with_phases, user: user) }

    #   it 'will mark the phase complete' do
    #     lead.phases.first.assignee = nil
    #     lead.phases.first.save
    #     params = { user_id: user.id, lead_id: lead.id, id: lead.phases.first.id, phase: lead.phases.first }
    #     byebug
    #     get :complete, params: params
    #     expect(flash[:alert]).to eq 'Phase marked as complete successfully'
    #   end
    # end
  end
end
