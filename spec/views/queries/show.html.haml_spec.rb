require 'rails_helper'

RSpec.describe "queries/show", :type => :view do
  before(:each) do
    @query = assign(:query, Query.create!(
      :user_id => 1,
      :query_content => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/MyText/)
  end
end
