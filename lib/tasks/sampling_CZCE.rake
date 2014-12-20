desc "Import cheng zhou commedies exchange"
namespace :sampling do
  task :czce => :environment do
    require File.expand_path('date_aggregate', File.dirname(__FILE__))
    include DateAggregate

    frequences = [
      :minute,
      :hour,
      :day,
      :week,
      :month,
      :second,
    ]


    # get target_month
    get_contract_month_by_product_type.each_with_index do |t, i|
      frequences.each do |frequence|
        if need_fill_empty? frequence
          query_cmd = get_query_command_interval_filling(frequence, t["contract_month"], t["product_type"], 'czces')
        else
          query_cmd = get_query_command(frequence, t["contract_month"], t["product_type"], 'czces')
        end
        print(query_cmd)
        ActiveRecord::Base.connection.execute(query_cmd).each_with_index do |raw_record, j|
          rec = raw_record.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
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
          ap(hft) if (j%1000==0)
        end
      end
    end


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