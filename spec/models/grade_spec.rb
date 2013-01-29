require 'spec_helper'

describe Grade do

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:rank) }
  it { should validate_numericality_of(:rank) }

  describe "default scope" do

    it "orders by rank in ascending order" do
      grade_2 = Grade.make! rank: 2
      grade_1 = Grade.make! rank: 1
      grade_3 = Grade.make! rank: 3

      Grade.all.should == [grade_1, grade_2, grade_3]
    end

  end

end
