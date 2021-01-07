# frozen_string_literal: true

require 'rails_helper'
RSpec.describe CommentsController, type: :controller do
  before do
    sign_in user
  end

  describe 'POST#create' do
    context 'with authorized user (eg. Business Developer)' do
      let(:user) { create(:user) }
      let(:lead) { create(:lead, :with_phase_comments, user: user) }
      let(:lead2) { create(:lead, :with_comments, user: user) }

      it 'will create a comment against a phase' do
        params = { user_id: user.id, lead_id: lead.id, phase_id: lead.phases.first.id,
                   comment: { body: ' hello ' } }
        expect do
          post :create, params: params
        end.to change(Comment, :count).by(1)
        expect(flash[:notice]).to eq 'Comment was created successfully.'
        expect(response.status).to eq(302)
      end

      it 'will create a comment against a lead' do
        params = { user_id: user.id, lead_id: lead2.id, comment: { body: ' hello ' } }
        expect do
          post :create, params: params
        end.to change(Comment, :count).by(1)
        expect(flash[:notice]).to eq 'Comment was created successfully.'
        expect(response.status).to eq(302)
      end

      it 'return failure ' do
        allow_any_instance_of(Comment).to receive(:save!).and_return(false)
        params = { user_id: user.id, lead_id: lead2.id, comment: { body: ' hello ' } }
        expect do
          post :create, params: params
        end.to change(Comment, :count).by(0)
      end
    end

    context 'with unauthorized user(business_developer trying to add comment on another business_developer phase)' do
      let(:user) { create(:user) }
      let(:user_business_developer) { create(:user) }
      let(:lead) { create(:lead, :with_phase_comments, user: user_business_developer) }

      it 'will not allow to destroy comment ' do
        params = { user_id: user.id, lead_id: lead.id, phase_id: lead.phases.first.id,
                   comment: { body: ' hello ' } }
        expect do
          post :create, params: params
        end.to change(Comment, :count).by(0)
        expect(flash[:alert]).to eq 'You are not authorized to perform this action.'
      end
    end
  end

  describe 'POST#destroy' do
    context 'with authorized user (eg. Business Developer)' do
      let(:user) { create(:user) }
      let(:lead) { create(:lead, :with_phase_comments, user: user) }
      let!(:lead2) { create(:lead, :with_comments, user: user) }

      it 'will destroy a comment against a phase' do
        params = { user_id: user.id, lead_id: lead.id, phase_id: lead.phases.first.id,
                   id: lead.phases.first.comments.first.id }
        expect do
          post :destroy, params: params
        end.to change(Comment, :count).by(-1)
        expect(response.status).to eq(302)
      end

      it 'will destroy a comment against a lead' do
        params = { user_id: user.id, lead_id: lead2.id, id: lead2.comments.first.id }
        expect do
          post :destroy, params: params
        end.to change(Comment, :count).by(-1)
        expect(response.status).to eq(302)
      end

      it 'will return failure raise exception that is handled by concerns' do
        allow_any_instance_of(Comment).to receive(:destroy).and_return(false)
        params = { user_id: user.id, lead_id: lead2.id, id: lead2.comments.first.id }
        expect do
          post :destroy, params: params
        end.to change(Phase, :count).by(0)
        expect(flash[:alert]).to eq 'couldn\'t destroy the record'
      end
    end

    context 'with unauthorized user (eg. Engineer)' do
      let(:user) { create(:user) }
      let(:user_business_developer) { create(:user) }
      let(:lead) { create(:lead, :with_phase_comments, user: user_business_developer) }

      it 'will not allow to destroy comment ' do
        params = { user_id: user.id, lead_id: lead.id, phase_id: lead.phases.first.id,
                   id: lead.phases.first.comments.first.id }
        post :destroy, params: params
        expect(flash[:alert]).to eq 'You are not authorized to perform this action.'
      end
    end
  end
end
