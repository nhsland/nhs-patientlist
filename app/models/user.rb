class User < ActiveRecord::Base
  has_many :patient_lists
  has_many :team_memberships
  has_many :teams, :through => :team_memberships

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me
end
