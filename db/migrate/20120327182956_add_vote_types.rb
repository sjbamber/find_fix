class AddVoteTypes < ActiveRecord::Migration
  def up
    VoteType.create!(:name => "positive")
    VoteType.create!(:name => "negative")
  end

  def down
    VoteType.find_by_name("negative").destroy
    VoteType.find_by_name("positive").destroy
  end
end
