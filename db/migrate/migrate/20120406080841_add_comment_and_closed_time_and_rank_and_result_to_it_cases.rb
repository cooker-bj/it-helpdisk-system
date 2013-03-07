class AddCommentAndClosedTimeAndRankAndResultToItCases < ActiveRecord::Migration
  def change
    add_column :it_cases, :comment, :text
    add_column :it_cases, :closed_time, :datetime
    add_column :it_cases, :rank, :integer
    add_column :it_cases, :result, :text
    add_column :it_cases, :closer, :string
  end
end
