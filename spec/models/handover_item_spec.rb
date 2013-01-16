require 'spec_helper'

describe HandoverItem do

  it { should validate_presence_of(:to_do_item) }
  it { should validate_presence_of(:patient_list_from) }
  it { should validate_presence_of(:patient_list_to) }

end
