class Handover < ActiveRecord::Base
  audited
  belongs_to :to_do_item
  belongs_to :handover_list

  validates_presence_of :to_do_item_id

  attr_accessible :to_do_item_id
end
