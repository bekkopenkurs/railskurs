require 'rspec'
require 'rock_paper_scissors'
describe RockPaperScissors do

  let (:game) { RockPaperScissors.new }

  specify "a new game should have zero players" do
    game.players.size.should == 0
  end

  it "should add players" do
    game.join(:player_a, :rock)
    game.players.size.should == 0 # <- fix this test first
  end

  pending "should require atleast two players" do
    game.players.size.should == 0
    expect { game.one_two_three_shoot! }.to raise_exception(NeedTwoPlayers)
  end

  describe "how to win games with two players" do
    pending "rock should beat scissors" do
      game.join(:player_a, :rock)
      game.join(:player_b, :scissors)
      game.one_two_three_shoot!
      game.winner.should == [:player_a]
    end

    pending "paper should beat rock" do
      game.join(:player_a, :rock)
      game.join(:player_b, :paper)
      game.one_two_three_shoot!
      game.winner.should == [:player_b]
    end

    pending "scissors should beat paper" do
      game.join(:player_a, :scissors)
      game.join(:player_b, :paper)
      game.one_two_three_shoot!
      game.winner.should == [:player_a]
    end

    pending "scissors and scissors should tie" do
      game.join(:player_a, :scissors)
      game.join(:player_b, :scissors)
      game.one_two_three_shoot!
      game.winner.should == [:tie]
    end
  end

  describe "how to win games with three players" do
    pending "rock should beat scissors" do
      game.join(:player_a, :rock)
      game.join(:player_b, :scissors)
      game.join(:player_c, :scissors)
      game.one_two_three_shoot!
      game.winner.should == [:player_a]
    end

    pending "scissors should beat paper" do
      game.join(:player_a, :paper)
      game.join(:player_b, :scissors)
      game.join(:player_c, :scissors)
      game.one_two_three_shoot!
      game.winner.should == [:player_b, :player_c]
    end

  end

end