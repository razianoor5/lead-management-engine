# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'associations' do
    it 'should belong to commentable' do
      comment = described_class.reflect_on_association(:commentable)
      expect(comment.macro).to eq(:belongs_to)
    end
  end
end
