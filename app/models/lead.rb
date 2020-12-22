# frozen_string_literal: true

class Lead < ApplicationRecord
  enum is_sale: { close: true, open: false }
  belongs_to :user
  has_many :phases
  has_many :comments, as: :commentable

  validates :client_name, format: { with: /\A[a-zA-Z]+\z/ }, presence: true
  validates :client_email, :client_address, :client_contact, :platform_used, :project_name, presence: true
  validates :client_contact, format: { with: /((\+92)|(0092))-{0,1}\d{3}-{0,1}\d{7}$|^\d{11}$|^\d{4}-\d{7}/ }
end
