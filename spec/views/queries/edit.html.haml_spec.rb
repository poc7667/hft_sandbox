require 'rails_helper'

RSpec.describe "queries/edit", :type => :view do
  before(:each) do
    @query = assign(:query, Query.create!(
      :user_id => 1,
      :query_content => "MyText"
    ))
  end

  it "renders the edit query form" do
    render

    assert_select "form[action=?][method=?]", query_path(@query), "post" do

      assert_select "input#query_user_id[name=?]", "query[user_id]"

      assert_select "textarea#query_query_content[name=?]", "query[query_content]"
    end
  end
end
