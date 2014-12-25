desc "Import cheng zhou commedies exchange"
namespace :sampling do
  task :czce => :environment do
    require File.expand_path('sql_helper', File.dirname(__FILE__))
    require File.expand_path('sampling_helper', File.dirname(__FILE__))
    include SqlHelper
    include SamplingHelper

    def fill_empty_sampling_interval?(frequence)
     if [:second, :minute, :hourly].include? frequence.to_sym
      return true
     else
      return false
     end
    end

    frequences = [ :second, :minute, :hour, :day, :week, :month,
    ]

    ["cffexes","czces"].each do |market|
      # get target_month
      get_contract_month_by_product_type(market).each_with_index do |t, i|
        frequences.each do |frequence|
          sampling_begin_time = get_sampling_begin_time(t, frequence)
          ap("Sampling begin time : #{sampling_begin_time}")
          if fill_empty_sampling_interval? frequence
            query_cmd = get_query_command_interval_filling(frequence, t["contract_month"], t["product_type"], market, sampling_begin_time)
          else
            query_cmd = get_query_command(frequence, t["contract_month"], t["product_type"], market, sampling_begin_time)
          end
          binding.pry
          ActiveRecord::Base.connection.execute(query_cmd).each_with_index do |raw_record, j|
            rec = raw_record.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
            begin
              hft = CzceHft.create(
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
              ap(query_cmd)          
              next
            end
            ap(hft) if (j%50000==0)
          end
        end
      end
    end # end of market

    # q_str = query_by_interval('minute', '2014-02-07 01:00:00', '2014-02-07 01:01:00')
    # p q_str
    # res = Czce.where{product_type == 'SR' }
    #       .where{ticktime >=  '2014-02-07 01:00:00'}
    #       .where{ticktime < '2014-02-07 01:01:00'}
    #       .where{ contract_month == '2014-09-01 00:00:00' }

    # last_volume = 0
    # res.each do |row|
    #   last_volume += row[:last_volume].to_i
    #   # ap(row)
    # end
    # # res.each do |row|
    # #   ap(row)
    # # end
    # binding.pry
    # ActiveRecord::Base.connection.execute(q_str).each do |row|
    #   binding.pry
    #   p row
    # end
    # binding.pry
    # p q_str


  end
end