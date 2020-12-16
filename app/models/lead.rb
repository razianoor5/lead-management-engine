# frozen_string_literal: true

class Lead < ApplicationRecord
  enum is_sale: { open: false, close: true }

  belongs_to :user
  has_many :phases, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  validates :client_name, presence: true
  validates :client_email, presence: true
end
