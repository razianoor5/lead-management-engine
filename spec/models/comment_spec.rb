# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'associations' do
    it 'belongs to commentable' do
      comment = described_class.reflect_on_association(:commentable)
      expect(comment.macro).to eq(:belongs_to)
    end
  end

  describe 'validations' do
    it 'body should be present' do
      comment = described_class.new
      expect(comment.save).to eq(false)
      expect(comment.errors.messages[:body]).to eq(['can\'t be blank'])
    end
  end
end
