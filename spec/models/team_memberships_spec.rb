require 'spec_helper'

describe TeamMembership do

  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:team_id) }
  it { should validate_uniqueness_of(:user_id).scoped_to(:team_id) }

end
