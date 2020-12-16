# frozen_string_literal: true

class Lead < ApplicationRecord
  belongs_to :user
  has_many :phases
  has_many :comments, as: :commentable

  validates :client_name, presence: true
  validates :client_email, presence: true
end
