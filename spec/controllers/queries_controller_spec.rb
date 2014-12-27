require 'rails_helper'

RSpec.describe QueriesController, :type => :controller do
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  let(:valid_session) { {} }

  describe "Get index" do
    # it "simple query" do
    #   get :index, {sample_freq: "day", begin_time: Date.today}
    # end

    skip "with start_dt and end_at, frequency: hour" do
      get :index, {
        market: "cffex_hfts",
        product: "IF",
        frequency: "hour",
        contract_month: "2014-03-01 00:00:00",
        start_dt: "2014-01-01 01:26:00",
        end_dt: "2014-01-30 08:26:00"
      }      
    end

    it "with delta 10 day freq in hour" do
      get :index, {
        market: "cffex_hfts",
        product: "IF",
        frequency: "hour",
        contract_month: "2014-03-01 00:00:00",
        event_dt: "2014-01-10 01:26:00",
        delta_time: "10day"
      }
    end

    it "with delta 5 hour freq in minute" do
      get :index, {
        market: "cffex_hfts",
        product: "IF",
        frequency: "minute",
        contract_month: "2014-03-01 00:00:00",
        event_dt: "2014-01-13 01:00:00",
        delta_time: "5hour"
      }
    end


  end

end
