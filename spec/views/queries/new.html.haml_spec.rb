require 'rails_helper'

RSpec.describe "queries/new", :type => :view do
  before(:each) do
    assign(:query, Query.new(
      :user_id => 1,
      :query_content => "MyText"
    ))
  end

  it "renders new query form" do
    render

    assert_select "form[action=?][method=?]", queries_path, "post" do

      assert_select "input#query_user_id[name=?]", "query[user_id]"

      assert_select "textarea#query_query_content[name=?]", "query[query_content]"
    end
  end
end
