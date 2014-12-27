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


#    contract_month    | product_type
# ---------------------+--------------
#  2014-01-01 00:00:00 | IF
#  2014-02-01 00:00:00 | IF
#  2014-03-01 00:00:00 | IF
#  2014-03-01 00:00:00 | TF
#  2014-04-01 00:00:00 | IF
#  2014-05-01 00:00:00 | IF
#  2014-06-01 00:00:00 | IF
#  2014-06-01 00:00:00 | TF
#  2014-07-01 00:00:00 | IF
#  2014-09-01 00:00:00 | IF
#  2014-09-01 00:00:00 | TF
#  2014-12-01 00:00:00 | IF
#  2014-12-01 00:00:00 | TF



    it "with start_dt and end_dt, frequency: second" do
      get :index, {
        market: "cffex_hfts",
        product: "IF",
        frequency: "second",
        contract_month: "2014-03-01 00:00:00",
        start_dt: "2014-01-20 05:26:00",
        end_dt: "2014-01-20 06:16:00"
      }
    end

    it "with start_dt and end_dt, frequency: second" do
      get :index, {
        market: "cffex_hfts",
        product: "TF",
        frequency: "second",
        contract_month: "2014-03-01 00:00:00",
        start_dt: "2014-01-20 05:26:00",
        end_dt: "2014-01-20 06:16:00"
      }
    end    

    it "with start_dt and end_dt, frequency: hour" do
      get :index, {
        market: "cffex_hfts",
        product: "IF",
        frequency: "hour",
        contract_month: "2014-03-01 00:00:00",
        start_dt: "2014-01-04 01:26:00",
        end_dt: "2014-01-14 08:26:00"
      }
    end

    it "with start_dt and end_dt, frequency: day" do
      get :index, {
        market: "cffex_hfts",
        product: "IF",
        frequency: "day",
        contract_month: "2014-02-01 00:00:00",
        start_dt: "2014-01-04 01:26:00",
        end_dt: "2014-01-14 08:26:00"
      }
    end

    it "with delta 10 day freq in hour" do
      get :index, {
        market: "cffex_hfts",
        product: "IF",
        frequency: "hour",
        contract_month: "2014-12-01 00:00:00",
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

    it "delta 17 hour, frequence:minute" do
      get :index, {
        market: "czce_hfts",
        product: "FG",
        frequency: "minute",
        contract_month: "2014-03-01 00:00:00",
        event_dt: "2014-01-13 01:00:00",
        delta_time: "17hour"
      }
    end

    it "delta 17 day, frequence:hour" do
      get :index, {
        market: "czce_hfts",
        product: "SR",
        frequency: "hour",
        contract_month: "2014-03-01 00:00:00",
        event_dt: "2014-01-13 01:00:00",
        delta_time: "17day"
      }
    end    

    it "delta 5 month, frequence:hour" do
      get :index, {
        market: "czce_hfts",
        product: "SR",
        frequency: "hour",
        contract_month: "2014-11-01 00:00:00",
        event_dt: "2014-01-13 01:00:00",
        delta_time: "5month"
      }
    end    


#    contract_month    | product_type
# ---------------------+--------------
#  2014-02-01 00:00:00 | FG
#  2014-02-01 00:00:00 | TC
#  2014-03-01 00:00:00 | OI
#  2014-03-01 00:00:00 | RM
#  2014-03-01 00:00:00 | SR
#  2014-04-01 00:00:00 | ME
#  2014-06-01 00:00:00 | TA
#  2014-08-01 00:00:00 | TA
#  2014-09-01 00:00:00 | OI
#  2014-09-01 00:00:00 | RS
#  2014-09-01 00:00:00 | WH
#  2014-11-01 00:00:00 | CF
#  2014-11-01 00:00:00 | PM
#  2014-12-01 00:00:00 | TA
#  2015-01-01 00:00:00 | CF
#  2015-01-01 00:00:00 | PM
#  2015-02-01 00:00:00 | TA
#  2015-03-01 00:00:00 | ME
#  2015-05-01 00:00:00 | FG
#  2015-05-01 00:00:00 | ME
#  2015-11-01 00:00:00 | SR


  end

end
