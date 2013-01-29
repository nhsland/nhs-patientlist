class Grade < ActiveRecord::Base
  attr_accessible :title, :rank

  validates :title, presence: true
  validates :rank, presence: true,
                   numericality: true

  default_scope order("rank ASC")
end
