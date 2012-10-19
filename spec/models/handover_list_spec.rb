require 'spec_helper'

describe HandoverList do
  it { should have_many(:handovers) }
  it { should belong_to(:team) }

  it { should validate_presence_of :team_id }
  it { should validate_presence_of :shift_date }
end
