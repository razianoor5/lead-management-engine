require 'rails_helper'
RSpec.describe CommentsController, type: :controller do
  before do
    user.save
    sign_in user
  end

  describe 'POST#create' do
    context 'when business developer signed in' do
      let(:user) { create(:user) }
      let(:lead) { create(:lead, :with_phase_comments, user: user) }
      let(:lead2) { create(:lead, :with_comments, user: user) }

      it 'will create a comment against a phase' do
        params = { user_id: user.id, lead_id: lead.id, phase_id: lead.phases.first.id,
                 comment: { body: ' hello ' } }
        post :create, params: params
        expect(response.status).to eq(302)
      end

      it 'will create a comment against a lead' do
        params = { user_id: user.id, lead_id: lead2.id, comment: { body: ' hello ' } }
        post :create, params: params
        expect(response.status).to eq(302)
      end
    end
  end
  describe 'POST#destroy' do
    context 'when business developer signed in' do
      let(:user) { create(:user) }
      let(:lead) { create(:lead, :with_phase_comments, user: user) }
      let(:lead2) { create(:lead, :with_comments, user: user) }

      it 'will destroy a comment against a phase' do
        params = { user_id: user.id, lead_id: lead.id, phase_id: lead.phases.first.id,
                  id: lead.phases.first.comments.first.id }
        post :destroy, params: params
        expect(response.status).to eq(302)
      end

      it 'will destroy a comment against a lead' do
        params = { user_id: user.id, lead_id: lead2.id, id: lead2.comments.first.id }
        post :destroy, params: params
        expect(response.status).to eq(302)
      end

      it 'will raise exeption that is handled by concerns ' do
        allow_any_instance_of(Comment).to receive(:destroy).and_return(false)
        params = { user_id: user.id, lead_id: lead2.id, id: lead2.comments.first.id }
        post :destroy, params: params
        expect(flash[:alert]).to eq 'couldn\'t destroy the record'
      end

      it 'will raise exeption that is handled by concerns ' do
        allow_any_instance_of(Comment).to receive(:destroy).and_return(false)
        params = { user_id: user.id, lead_id: lead.id, phase_id: lead.phases.first.id,
                  id: lead.phases.first.comments.first.id }
        post :destroy, params: params
        expect(flash[:alert]).to eq 'couldn\'t destroy the record'
      end
    end
  end
end
