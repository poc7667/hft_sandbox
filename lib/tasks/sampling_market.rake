desc "Import cheng zhou commedies exchange"
namespace :sampling do
  task :market => :environment do
    require File.expand_path('sql_helper', File.dirname(__FILE__))
    require File.expand_path('sampling_helper', File.dirname(__FILE__))
    include SqlHelper
    include SamplingHelper

    frequences = [ :day, :second, :minute, :hour, :week, :month, :year]
    markets = [
      {"name" => "cffexes", "model_name" => "CffexHft", "hft_table_name" => "cffex_hfts"},
      {"name" => "czces", "model_name" => "CzceHft", "hft_table_name" => "czce_hfts"},
    ]

    markets.each do |market|
      # get target_month
      ap("Current market #{market}")
      get_contract_month_by_product_type(market["name"]).each_with_index do |t, i|
        frequences.each do |frequence|          
          query_expression = get_query_command_by_interval_or_normal(frequence, t, market)
          ap(query_expression)
          ActiveRecord::Base.connection.execute(query_expression).each_with_index do |raw_record, j|
            rec = raw_record.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
            begin
              # next if no_data_on_this_day?(rec, frequence, market["model_name"])
              hft = market["model_name"].constantize.create(
                  product_type: t["product_type"],
                  contract_month: t["contract_month"],
                  open: rec[:open].to_f,
                  high: rec[:high].to_f,
                  low: rec[:low].to_f,
                  close: rec[:close].to_f,
                  volume: rec[:volume].to_f,
                  frequence: frequence,
                  time: rec[:time],
                )
            rescue Exception => e
              ap(e)
              ap(query_expression)
              next
            end
            ap(hft) if (j%200000==0) and j > 20000
          end
        end
      end
    end # end of market
  end
end