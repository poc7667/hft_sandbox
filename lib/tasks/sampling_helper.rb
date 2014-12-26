module SamplingHelper
  require File.expand_path('sql_helper', File.dirname(__FILE__))
  include SqlHelper

  def get_contract_month_by_product_type(market)
    ActiveRecord::Base.connection.execute(
      %{SELECT DISTINCT
        contract_month, product_type
        FROM #{market};}
      )
  end

  def get_sampling_begin_time(info, frequncy, market)
      record = (market.constantize).where{"contract_month = '#{info["contract_month"]}'"}
                 .where{"product_type = '#{info["product_type"]}'"}
                 .where{" frequence = '#{frequncy}'"}
                 .order('time DESC').first
      unless record.nil?
        return record.time
      else
        return Time.at(0).to_datetime
      end
  end

  def fill_empty_sampling_interval?(frequence)
   if [:second, :minute, :hourly].include? frequence.to_sym
    return true
   else
    return false
   end
  end  

  def get_query_command_by_interval_or_normal(frequence, t, market)

    sampling_begin_time = get_sampling_begin_time(t, frequence, market["model_name"])
    ap("Sampling begin time : #{sampling_begin_time}")
    if fill_empty_sampling_interval? frequence
      return get_query_command_interval_filling(frequence, 
                t["contract_month"], 
                t["product_type"], 
                market["name"], 
                sampling_begin_time, 
                market["hft_table_name"])
    else
      return get_query_command(frequence, t["contract_month"], t["product_type"], market["name"], sampling_begin_time)
    end
    
  end

  def no_data_on_this_day?(rec, frequence, market)
    if ([:second, :minute, :hour].include? frequence) and (0 == market.constantize.where{"frequence = 'day'"}.where{"time = '#{Date.parse(rec[:time])}'"}.count)
      return true
    else
      return false
    end
  end



end
