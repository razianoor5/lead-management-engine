# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  enum role: { super_admin: 1, business_developer: 2, technical_manager: 3, engineer: 4 }
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :leads
end
