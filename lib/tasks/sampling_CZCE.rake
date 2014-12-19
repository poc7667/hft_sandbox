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
      ap(t)
      frequences.each do |frequency|
        query_cmd = get_query_command(frequency, t["contract_month"], t["product_type"], 'czces')
        ActiveRecord::Base.connection.execute(query_cmd).each_with_index do |raw_record, j|
          rec = raw_record.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
          hft = CzceHft.create(
              product_type: t["product_type"],
              contract_month: t["contract_month"],
              open: rec[:open],
              high: rec[:high],
              low: rec[:low],
              close: rec[:close],
              volume: rec[:volume],
              frequency: frequency,
              ticktime: rec[:ticktime],
            )
          ap(hft) if (j%10==0)
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