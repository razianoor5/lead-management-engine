# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Phase, type: :model do
  describe 'associations' do
    it 'should belongs to lead' do
      lead = described_class.reflect_on_association(:user)
      expect(lead.macro).to eq(:belongs_to)
    end

    it 'should have many phases' do
      lead = described_class.reflect_on_association(:phases)
      expect(lead.macro).to eq(:has_many)
    end

    it 'should have many comments' do
      lead = described_class.reflect_on_association(:comments)
      expect(lead.macro).to eq(:has_many)
    end
  end
end
