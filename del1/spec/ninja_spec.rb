require 'rspec'
require 'ninja'

describe Ninja do

  let(:ninja) { Ninja.new({:shuriken => 1}) }

  it "should have katana" do
    ninja.katana?.should be true
  end

  it "should have a shuriken" do
    ninja.shuriken.should == 1
  end

  it "should have no shuriken after flinging off a shuriken" do
    ninja.fling!
    ninja.shuriken.should == 0
  end

  it "should not be able to throw if it has no shuriken left" do
    ninja.fling!
    expect { ninja.fling! }.to raise_exception(CantDoThat)
  end

  describe "a ninja's fighting ethos" do
    it "should always engage in attack" do
      ninja.attack!
      ninja.status.should be :engaged
    end

    specify "except when the opponent is 'Chuck Norris'" do
      ninja.attack! 'Chuck Norris'
      ninja.status.should be :running
    end

  end

end