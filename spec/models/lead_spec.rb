# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lead, type: :model do
  describe 'associations' do
    it 'belongs to user' do
      lead = described_class.reflect_on_association(:user)
      expect(lead.macro).to eq(:belongs_to)
    end

    it 'has many phases' do
      lead = described_class.reflect_on_association(:phases)
      expect(lead.macro).to eq(:has_many)
    end

    it 'phases are dependent on destroy' do
      association = described_class.reflect_on_association(:phases)
      expect(association.options[:dependent]).to eq(:destroy)
    end

    it 'comments are dependent on destroy' do
      association = described_class.reflect_on_association(:comments)
      expect(association.options[:dependent]).to eq(:destroy)
    end

    it 'has many comments' do
      lead = described_class.reflect_on_association(:comments)
      expect(lead.macro).to eq(:has_many)
    end
  end

  describe 'validations' do
    it 'platform used field should be present ' do
      lead = described_class.new
      expect(lead.save).to eq(false)
      expect(lead.errors.messages[:platform_used]).to eq(['can\'t be blank'])
    end

    it 'test client name should be present' do
      lead = described_class.new
      expect(lead.save).to eq(false)
      expect(lead.errors.messages[:client_name]).to eq(['is invalid', 'can\'t be blank'])
    end

    it 'test client email should be present' do
      lead = described_class.new
      expect(lead.save).to eq(false)
      expect(lead.errors.messages[:client_email]).to eq(['can\'t be blank'])
    end

    it 'test client contact should be present' do
      lead = described_class.new
      expect(lead.save).to eq(false)
      expect(lead.errors.messages[:client_contact]).to eq(['can\'t be blank', 'is invalid'])
    end

    it 'project should be present' do
      lead = described_class.new
      expect(lead.save).to eq(false)
      expect(lead.errors.messages[:project_name]).to eq(['can\'t be blank'])
    end

    context 'with format of client name' do
      let!(:user) { create(:user) }

      it 'client name should be in alphabets' do
        lead = described_class.new(client_name: 'riznr', client_email: 'abc@gmail.com', client_address: 'Lahore',
                                   client_contact: '03494917663', platform_used: 'abc', project_name: 'devsinc',
                                   user: user)
        expect(lead.save).to eq(true)
      end

      it 'client name should not be in alphabets' do
        lead = described_class.new(client_name: 'riznr12', client_email: 'abc@gmail.com', client_address: 'Lahore',
                                   client_contact: '03494917663', platform_used: 'abc', project_name: 'devsinc',
                                   user: user)
        expect(lead.save).to eq(false)
        expect(lead.errors.messages[:client_name]).to eq(['is invalid'])
      end
    end

    context 'when format of client_contact is true' do
      let!(:user) { create(:user) }

      it 'phone number in correct format ' do
        lead = described_class.new(client_name: 'riznr', client_email: 'abc@gmail.com', client_address: 'Lahore',
                                   client_contact: '03494917663', platform_used: 'abc', project_name: 'devsinc',
                                   user: user)
        expect(lead.save).to eq(true)
      end

      it 'phone number not in correct format ' do
        lead = described_class.new(client_name: 'riznr12', client_email: 'abc@gmail.com', client_address: 'Lahore',
                                   client_contact: '134949176', platform_used: 'abc', project_name: 'devsinc',
                                   user: user)
        expect(lead.save).to eq(false)
        expect(lead.errors.messages[:client_contact]).to eq(['is invalid'])
      end
    end
  end
end
