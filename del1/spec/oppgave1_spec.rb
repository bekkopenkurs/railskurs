require 'rspec'

# ************************************************
# TODO: last inn greeter ved å ta vekk kommentar #
# ************************************************
#require 'greeter'


#
# Eksempel på gammeldags type teststil
#
describe Greeter do

  it "should say 'Hello!' when it receives the greet() message" do
    greeter = Greeter.new
    greeting = greeter.greet
    greeting.should == "Hello."
  end

end

#
# Eksempel som gjør det samme med et subject (subject under test)
#
describe Greeter do

  subject { Greeter.new }

  describe "#greet" do

    it "should say 'Hello.' when it receives a greet() message without params" do
      subject.greet.should eq "Hello."
    end

  end
end

#
# Eksempel som gjør det samme, men bruker let {}
#
describe Greeter do

  let (:greeter) { Greeter.new }

  describe "#greet" do

    it "should say 'Hello.' when it receives a greet() message without params" do
      greeter.greet.should eq "Hello."
    end

  end
end


describe Greeter do

  describe "#greet" do
    subject { Greeter.new }

    # **********************************
    # TODO: Bytt ut 'pending' med 'it' #
    # **********************************
    pending "should say 'Hello OC!' when it receives the greet() message with parameter" do
      subject.greet('OC').should == "Hello OC!"
    end

    # ************************************************
    # TODO: Bytt ut 'pending' med 'it'               #
    # TODO: implementer feilende test (i greeter.rb) #
    # ************************************************
    pending "should say 'Hello BOSS!' when message is 'Torstein'" do
      subject.greet('Torstein').should == "Hello BOSS!"
    end

  end
end

