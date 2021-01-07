# frozen_string_literal: true

puts "rspec pid: #{Process.pid}"
require 'rails_helper'

RSpec.describe PhasesController, type: :controller do
  before do
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

    it 'shows index conetnt type to be text/html' do
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
    context 'with authorized user (business_developer)' do
      let(:user) { create(:user) }
      let(:lead) { create(:lead, :with_phases, user: user) }

      it 'show success when user is business_developer' do
        params = { user_id: user.id, lead_id: lead.id, id: lead.phases.first.id }
        get :edit, params: params
        expect(response.status).to eq(200)
      end
    end

    context 'with unauthorized user (eg. engineer)' do
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
                                              due_date: Faker::Date.between(from: '2020-12-23', to: '2020-12-30'),
                                              lead_id: lead.id } }
        expect do
          post :create, params: params
        end.to change(Phase, :count).by(1)
      end

      it 'will not create phase as assignee is not technical_manager' do
        params = { lead_id: lead.id, phase: { phase_type: 'Test', assignee: user.email,
                                              start_date: Faker::Date.between(from: '2020-12-11', to: '2020-12-22'),
                                              due_date: Faker::Date.between(from: '2020-12-23', to: '2020-12-30'),
                                              lead_id: lead.id } }
        expect do
          post :create, params: params
        end.to change(Phase, :count).by(0)
      end
    end

    context 'with unauthorized user (eg. Technical Manager)' do
      let(:user_bd) { create(:user) }
      let(:user) { create(:user, :technical_manager) }
      let(:user_manager) { create(:user, :technical_manager) }
      let(:lead) { create(:lead, :with_phases, user: user_bd) }

      it 'will not allow to create phase ' do
        params = { lead_id: lead.id, phase: { phase_type: 'Test', assignee: user_manager.email,
                                              start_date: Faker::Date.between(from: '2020-12-11', to: '2020-12-22'),
                                              due_date: Faker::Date.between(from: '2020-12-23', to: '2020-12-30'),
                                              lead_id: lead.id } }
        post :create, params: params
        expect(flash[:alert]).to eq 'You are not authorized to perform this action.'
      end
    end
  end

  describe 'PUT/PATCH #update' do
    context 'with authorized user (Owner of phase , Business Developer)' do
      let(:user) { create(:user) }
      let(:lead) { create(:lead, :with_phases, user: user) }

      it 'update phase when user is business_developer' do
        params = { user_id: user.id, lead_id: lead.id, id: lead.phases.first.id, phase: { phase_type: 'Interview' } }
        put :update, params: params
        expect(lead.phases.first.reload.phase_type).to eq('Interview')
        expect(response.status).to eq(302)
        expect(flash.now[:notice]).to eq 'Phase was successfully updated.'
      end

      it 'return failure' do
        params = { user_id: user.id, lead_id: lead.id, id: lead.phases.first.id, phase: { phase_type: '' } }
        put :update, params: params
        expect(lead.phases.first.reload.phase_type).to eq('Test')
        expect(response.status).to eq(200)
        expect(flash[:notice]).to eql 'Phase was not updated.'
      end
    end

    context 'with unauthorized user (Business Developer not owner of that phase)' do
      let(:user) { create(:user) }
      let(:user_bd) { create(:user) }
      let(:lead) { create(:lead, :with_phases, user: user_bd) }

      it 'will not allow to update phase' do
        params = { user_id: user.id, lead_id: lead.id, id: lead.phases.first.id, phase: { phase_type: 'Intervi' } }
        put :update, params: params
        expect(lead.phases.first.reload.phase_type).to eq('Test')
        expect(flash[:alert]).to eq 'You are not authorized to perform this action.'
      end
    end
  end

  describe 'POST #destroy' do
    context 'with authorized user (Business Developer that is Owner of phase)' do
      let(:user) { create(:user) }
      let(:lead) { create(:lead, :with_phases, user: user) }

      it 'show success when user is business_developer' do
        params = { user_id: user.id, lead_id: lead.id, id: lead.phases.first.id }
        expect do
          post :destroy, params: params
        end.to change(Phase, :count).by(-1)
        expect(flash[:notice]).to eq 'Phase was successfully destroyed.'
      end

      it 'will redirect to phases index after deleting the phase' do
        params = { lead_id: lead.id, id: lead.phases.first.id }
        expect do
          post :destroy, params: params
        end.to change(Phase, :count).by(-1)
        expect(response).to redirect_to lead_phases_url
      end

      it 'return failure' do
        allow_any_instance_of(Phase).to receive(:destroy).and_return(false)
        params = { user_id: user.id, lead_id: lead.id, id: lead.phases.first.id }
        expect do
          post :destroy, params: params
        end.to change(Phase, :count).by(0)
        expect(flash[:alert]).to eq 'Phase was not destroyed.'
      end
    end

    context 'with unauthorized user (not owner of the phase)' do
      let(:user) { create(:user, :technical_manager) }
      let(:user_bd) { create(:user) }
      let(:lead) { create(:lead, :with_phases, user: user_bd) }

      it 'will not allow to delete phase when user is not business_developer' do
        params = { lead_id: lead.id, id: lead.phases.first.id }
        expect do
          post :destroy, params: params
        end.to change(Phase, :count).by(0)
        expect(flash[:alert]).to eq 'You are not authorized to perform this action.'
      end

      it 'will redirect to phases index ' do
        params = { lead_id: lead.id, id: lead.phases.first.id }
        expect do
          post :destroy, params: params
        end.to change(Phase, :count).by(0)
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
        count = lead.phases.first.users.count
        params = { user_id: user.id, lead_id: lead.id, id: lead.phases.first.id, engineer: { user_id: user_eng.id } }
        post :engineer, params: params
        expect(lead.phases.first.users.count).not_to eq(count)
        expect(flash[:notice]).to eq 'Engineer was successfully added.'
      end
    end

    context 'when engineer already assigned' do
      let(:user) { create(:user, email: lead.phases.first.assignee) }
      let(:user_bd) { create(:user) }
      let(:lead) { create(:lead, :with_phases, user: user_bd) }
      let(:user_eng) { create(:user, :engineer) }

      it 'will not assign engineer' do
        count = lead.phases.first.users.count
        params = { user_id: user.id, lead_id: lead.id, id: lead.phases.first.id,
                   engineer: { user_id: lead.phases.first.users.first.id } }
        post :engineer, params: params
        expect(lead.phases.first.users.count).to eq(count)
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
        expect(lead.phases.first.completed?).to eq(true)
        expect(flash[:alert]).to eq 'Phase marked as complete successfully'
      end
    end
  end
end
