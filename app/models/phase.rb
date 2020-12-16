# frozen_string_literal: true

class Phase < ApplicationRecord
  enum is_complete: { pending: false, completed: true }
  belongs_to :lead
  has_many :comments, as: :commentable, dependent: :destroy
  has_and_belongs_to_many :users
  validates :phase_type, :assignee, :start_date, :due_date, presence: true
end
