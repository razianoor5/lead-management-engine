# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Phase, type: :model do
  describe 'associations' do
    it 'should have many users' do
      phase = described_class.reflect_on_association(:users)
      expect(phase.macro).to eq(:has_and_belongs_to_many)
    end

    it 'should belong to lead' do
      phase = described_class.reflect_on_association(:lead)
      expect(phase.macro).to eq(:belongs_to)
    end

    it 'should have many comments' do
      phase = described_class.reflect_on_association(:comments)
      expect(phase.macro).to eq(:has_many)
    end
  end
end
