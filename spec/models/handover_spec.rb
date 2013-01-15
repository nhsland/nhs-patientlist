require 'spec_helper'

describe Handover do
  it { should belong_to(:to_do_item) }
  it { should validate_presence_of(:to_do_item_id) }

  it "is audited in creation" do
    handover = Handover.make!
    handover.audits.count.should == 1
    handover.audits.first.action.should == "create"
  end
end
