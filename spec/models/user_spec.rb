require 'spec_helper'

describe User do

  it { should have_many(:team_memberships) }
  it { should have_many(:teams).through(:team_memberships) }

end
