class LeadSerializer < ActiveModel::Serializer
  attributes :id, :client_name, :client_email, :client_address, :client_contact, :platform_used, :project_name
  has_one :user
  has_many :comments
end
