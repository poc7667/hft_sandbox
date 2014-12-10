require 'rails_helper'

RSpec.describe "queries/index", :type => :view do
  before(:each) do
    assign(:queries, [
      Query.create!(
        :user_id => 1,
        :query_content => "MyText"
      ),
      Query.create!(
        :user_id => 1,
        :query_content => "MyText"
      )
    ])
  end

  it "renders a list of queries" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
